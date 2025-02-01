import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";
import { assert, is } from "jsr:@core/unknownutil";

export const main: Entrypoint = async (denops : Denops) => {
    denops.dispatcher = {
        async init(){
            // NOTE: if we want to stop the interval, we'd need the interval ID
            setInterval(async () => {
                if(!Deno.env.has("TZ") || Deno.env.get("TZ")){
                    Deno.env.set("TZ", "America/Los_Angeles")
                }
                const date_cmd = new Deno.Command("date", {
                  args: ["+%r"],
                });
                const { _code, stdout, _stderr } = await date_cmd.output();
                vars.globals.set(denops, "myTime", new TextDecoder().decode(stdout).trim())
                vars.globals.set(denops, "myStatuslineUpdated", 1)
            }, 5000);
        },
        version(){
        },
    };
};
