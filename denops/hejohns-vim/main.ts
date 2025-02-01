import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as std from "jsr:@std/assert";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";
import { assert, is } from "jsr:@core/unknownutil";

type interval_ID = number;

async function system(cmd : string[]) : Promise<string> {
    std.assert(cmd.length > 0);
    const exec = cmd.shift();
    assert(exec, is.String);
    const system_cmd = new Deno.Command(exec, {
      args: cmd,
      stdout: "piped",
    });
    const { stdout } = await system_cmd.output();
    return new TextDecoder().decode(stdout).trim();
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
                        if(!Deno.env.has("TZ") || Deno.env.get("TZ")){
                            Deno.env.set("TZ", "America/Los_Angeles")
                        }
                        const time = await system(["date", "+%r"]);
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
            const plugs_obj = JSON.parse(plugs)
            helper.echo(denops, "hejohns-vim][debug] " + JSON.stringify(plugs_obj));
            return;
            const cwd = Deno.cwd(); // this should probably be in some sort of finalizer
            Object.keys(plugs_obj).map(async (plugin) => {
                const info = plugs_obj[plugin];
                helper.echo(denops, "[hejohns-vim] " + JSON.stringify(info));
                return;
                Deno.chdir(info['dir']);
                const git_status = await system(["git", "status", "--porcelain", "-bz"]);
                const re = /[behind \d+]$/;
                if(re.test(git_status)){
                    helper.echo(denops, "[hejohns-vim] A");
                }
                else{
                    helper.echo(denops, "[hejohns-vim] B");
                }
            });
        },
    };
};
