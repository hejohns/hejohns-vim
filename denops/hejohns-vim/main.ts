import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";
import { assert, is } from "jsr:@core/unknownutil";

type interval_ID = number;

export const main: Entrypoint = async (denops : Denops) => {
    let intervals : { [name: string]: interval_ID } = {};
    denops.dispatcher = {
        async init(){
        },
        start_timers(names){
            assert(names, is.ArrayOf(is.String));
            names.forEach(name => {
                if(name == "statusline_time"){
                    intervals[name] = setInterval(async () => {
                        if(!Deno.env.has("TZ") || Deno.env.get("TZ")){
                            Deno.env.set("TZ", "America/Los_Angeles")
                        }
                        const date_cmd = new Deno.Command("date", {
                          args: ["+%r"],
                          stdout: "piped",
                        });
                        const { stdout } = await date_cmd.output();
                        vars.globals.set(denops, "hejohns#time", new TextDecoder().decode(stdout).trim())
                        vars.globals.set(denops, "hejohns#statusline_updated", 1)
                    }, 5000);
                }
                else{
                    helper.echoerr(denops, "[hejohns-vim] '" + name + "' is not a known timer");
                }
            });
        },
        stop_timers(names){
            assert(names, is.ArrayOf(is.String));
            names.forEach(name => clearInterval(intervals[name]));
        },
    };
};
