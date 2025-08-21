import { BaseConfig, ConfigArguments } from "jsr:@shougo/ddc-vim@~8.1.0/config";

export class Config extends BaseConfig {
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
        "skkeleton_okuri",
        "lsp",
        "vsnip",
        "file",
        "buffer",
      ],
      cmdlineSources: {
        ":": ["cmdline", "buffer"],
        "/": ["buffer"],
        "?": ["buffer"],
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_fuzzy"],
          sorters: ["sorter_fuzzy"],
          converters: ["converter_fuzzy", "converter_remove_overlap"],
          minAutoCompleteLength: 1,
          ignoreCase: true,
        },
        buffer: {
          mark: "[B]",
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
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
          minAutoCompleteLength: 1,
        },
        skkeleton_okuri: {
          mark: "[SKK*]",
          matchers: [],
          sorters: [],
          converters: [],
          isVolatile: true,
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
          enableResolveItem: true,
          snippetEngine: await args.denops.eval(
            "denops#callback#register({ body -> vsnip#anonymous(body) })",
          ),
          enableAdditionalTextEdit: true,
          confirmBehavior: "replace",
        },
        buffer: {
          requireSameFiletype: false,
          limitBytes: 5000000,
          fromAltBuf: true,
          forceCollect: true,
        },
      },
    });
  }
}
