import type { Entrypoint, Denops } from "jsr:@denops/std";
import * as batch from "jsr:@denops/std/batch";
import * as fn from "jsr:@denops/std/function";
import * as vars from "jsr:@denops/std/variable";
import * as helper from "jsr:@denops/std/helper";
import { assert, is } from "jsr:@core/unknownutil";

export const main: Entrypoint = async (denops : Denops) => {
    denops.dispatcher = {
        async init(){
            setInterval(() => {
                helper.echo(denops, 'test this timer');
            }, 5000);
        },
        version(){
            setInterval(() => {
                helper.echo(denops, 'test this timer');
            }, 5000);
        },
    };
};
