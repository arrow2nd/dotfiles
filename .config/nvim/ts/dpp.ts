// 参考:
// https://github.com/Shougo/shougo-s-github/blob/956e1c5a908b4f2cb15fbcb0e2c1f956cc7aa2d6/vim/rc/dpp.ts

import type { Denops } from "jsr:@denops/std@~7.3.0";
import type { Dpp } from "jsr:@shougo/dpp-vim@~3.1.0/dpp";
import type {
  ContextBuilder,
  ExtOptions,
  Plugin,
} from "jsr:@shougo/dpp-vim@~3.1.0/types";
import {
  BaseConfig,
  type ConfigReturn,
  MultipleHook,
} from "jsr:@shougo/dpp-vim@~3.1.0/config";
import { mergeFtplugins } from "jsr:@shougo/dpp-vim@~3.1.0/utils";
import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "jsr:@shougo/dpp-ext-toml@~1.3.0";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "jsr:@shougo/dpp-ext-lazy@~1.5.0";
import { Protocol } from "jsr:@shougo/dpp-vim@~3.1.0/protocol";
import { expandGlobSync } from "jsr:@std/fs@~1.0.0/expand-glob";

type Args = {
  denops: Denops;
  contextBuilder: ContextBuilder;
  basePath: string;
  dpp: Dpp;
};

const tomlDir = `${Deno.env.get("HOME")}/.config/nvim/toml`;

// 読み込む toml ファイルのリスト
const tomlList: Array<[`${string}.toml`, boolean]> = [
  ["eager.toml", false],
  ["lazy.toml", true],
  ["ddc.toml", false],
  ["lsp.toml", false],
];

export class Config extends BaseConfig {
  override async config(args: Args): Promise<ConfigReturn> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      string,
      Protocol
    >;

    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    let multipleHooks: MultipleHook[] = [];

    const [tomlExtension, tomlOptions, tomlParams] = await args.denops
      .dispatcher
      .getExt(
        "toml",
      ) as [TomlExt | undefined, ExtOptions, TomlParams];

    if (tomlExtension) {
      const action = tomlExtension.actions.load;

      const tomlPromises = tomlList.map(([filename, lazy]) => {
        return action.callback({
          denops: args.denops,
          context,
          options,
          protocols,
          extOptions: tomlOptions,
          extParams: tomlParams,
          actionParams: {
            path: `${tomlDir}/${filename}`,
            options: {
              lazy,
            },
          },
        });
      });

      const tomls = await Promise.all(tomlPromises);

      // Merge toml results
      for (const toml of tomls) {
        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          mergeFtplugins(ftplugins, toml.ftplugins);
        }

        if (toml.multiple_hooks) {
          multipleHooks = multipleHooks.concat(toml.multiple_hooks);
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      }
    }

    const [lazyExtension, lazyOptions, lazyParams] = await args.denops
      .dispatcher.getExt(
        "lazy",
      ) as [LazyExt | undefined, ExtOptions, LazyParams];

    let lazyResult: LazyMakeStateResult | undefined;

    if (lazyExtension) {
      const action = lazyExtension.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    const checkFiles = [...expandGlobSync(`${tomlDir}/*`)].map((file) =>
      file.path
    );

    return {
      checkFiles,
      ftplugins,
      hooksFiles,
      multipleHooks,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
