import { BaseConfig, ConfigArguments } from "jsr:@shougo/ddc-vim@~8.1.0/config";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      ui: "pum",
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineChanged",
      ],
      sources: [
        "skkeleton",
        "lsp",
        "vsnip",
        "file",
        "around",
      ],
      cmdlineSources: {
        "_": ["cmdline", "cmdline-history", "around"],
        "/": ["around"],
        "?": ["around"],
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: ["converter_fuzzy", "converter_remove_overlap"],
          minAutoCompleteLength: 1,
          ignoreCase: true,
        },
        around: {
          mark: "[A]",
        },
        lsp: {
          mark: "[L]",
          sorters: ["sorter_lsp-kind", "sorter_fuzzy"],
          dup: "keep",
          keywordPattern: "[a-zA-Z0-9_À-ÿ$#\\-*]*",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
        },
        file: {
          mark: "[F]",
          isVolatile: true,
          ignoreCase: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        skkeleton: {
          mark: "[SKK]",
          matchers: ["skkeleton"],
          sorters: [],
          converters: [],
          isVolatile: true,
          minAutoCompleteLength: 2,
        },
        cmdline: {
          mark: "[C]",
        },
        cmdlineHistory: {
          mark: "[H]",
        },
      },
      filterParams: {
        matcher_fuzzy: {
          splitmode: "word",
        },
      },
      sourceParams: {
        lsp: {
          snippetEngine:
            `denops#callback#register({ body -> vsnip#anonymous(body) })`,
          enableResolveItem: true,
          enableAdditionalTextEdit: true,
          confirmBehavior: "replace",
        },
      },
    });
  }
}
