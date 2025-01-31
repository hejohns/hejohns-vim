import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";

export const main: Entrypoint = async (denops : Denops) => {
    denops.dispatcher = {
        async init(){
            helper.echo(denops, "test this??");
        },
    };
};
