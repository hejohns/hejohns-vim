import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as std from "jsr:@std/assert";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";
import { assert, ensure, is } from "jsr:@core/unknownutil";

type interval_ID = number;

function _system_Command(cmd : string[], opt : Deno.CommandOptions) : Deno.Command {
    std.assert(cmd.length > 0);
    const exec = cmd.shift();
    assert(exec, is.String);
    opt.args = cmd;
    return new Deno.Command(exec, opt);
}

interface CommandOutputStringStdout extends Deno.CommandStatus {
    stdout: string,
};
interface CommandOutputStringStderr extends Deno.CommandStatus {
    stderr: string,
};
type CommandOutputString2 = CommandOutputStringStdout & CommandOutputStringStderr

async function system(cmd : string[], opt? : Deno.CommandOptions) : Promise<CommandOutputStringStdout> {
    opt = opt ?? {}
    opt.stdout = "piped";
    const { stdout, ...rest } = await _system_Command(cmd, opt).output();
    return { stdout: new TextDecoder().decode(stdout).trim(), ...rest };
};

async function system2(cmd : string[], opt? : Deno.CommandOptions) : Promise<CommandOutputString2> {
    opt = opt ?? {}
    opt.stdout = "piped"
    opt.stderr = "piped"
    const { stdout, stderr, ...rest } = await _system_Command(cmd, opt).output();
    const td = new TextDecoder()
    return { stdout: td.decode(stdout).trim(), stderr: td.decode(stderr).trim(), ...rest };
};

export const main: Entrypoint = async (denops : Denops) => {
    let intervals : { [name: string]: interval_ID } = {};
    denops.dispatcher = {
        async init(){
        },
        start_timers(names){
            assert(names, is.ArrayOf(is.String));
            names.forEach(name => {
                if(Object.hasOwn(intervals, name)){
                    helper.echo(denops, `[hejohns-vim][warning] timer '${name}' was stopped and restarted`);
                    clearInterval(intervals[name]);
                }
                if(name == "statusline_time"){
                    intervals[name] = setInterval(async () => {
                        if(!Deno.env.has("TZ") || ensure(Deno.env.get("TZ"), is.String).length == 0){
                            Deno.env.set("TZ", "America/Los_Angeles")
                        }
                        const {stdout: time} = await system(["date", "+%r"]);
                        await batch.batch(denops, async (denops) => {
                            await vars.globals.set(denops, "hejohns#time", time)
                            await vars.globals.set(denops, "hejohns#statusline_updated", 1)
                        });
                    }, 5000);
                }
                else{
                    helper.echoerr(denops, "[hejohns-vim] '" + name + "' is not a known timer");
                }
            });
        },
        stop_timers(names){
            assert(names, is.ArrayOf(is.String));
            names.forEach(name => {
                clearInterval(intervals[name]);
                delete intervals[name];
            });
        },
        async PlugUpdate(plugs){
            assert(plugs, is.String);
            const plugs_obj = JSON.parse(plugs);
            const plugins_updated = await Promise.all(Object.keys(plugs_obj).map(async (plugin) => {
                const info = plugs_obj[plugin];
                const git_fetch = await system(["git", "fetch", "--all"], {cwd: info['dir']});
                std.assert(git_fetch.success);
                const git_status = await system(["git", "status", "--porcelain", "-bz"], {cwd: info['dir']});
                std.assert(git_status.success);
                const re = /behind \d+]/;
                if(re.test(git_status.stdout)){
                    const git_pull = await system2(["git", "pull"], {cwd: info['dir']});
                    if(git_pull.success){
                        return true;
                    }
                    else{
                        helper.echoerr(denops, `[hejohns-vim][error] git pull '${info['dir']}' failed: ${git_pull.stderr}`);
                    }
                }
                return false;
            }));
            return plugins_updated.filter(x => x).length
        },
    };
};
