import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddu-vim@~6.4.0/config";

export class Config extends BaseConfig {
  // deno-lint-ignore require-await
  override async config(args: ConfigArguments): Promise<void> {
    args.contextBuilder.patchGlobal({
      sourceParams: {
        anyjump_definition: {
          highlights: {
            path: "Normal",
            lineNr: "Normal",
            word: "Title",
          },
          removeCommentsFromResults: true,
        },
        anyjump_reference: {
          highlights: {
            path: "Normal",
            lineNr: "Normal",
            word: "Title",
          },
          removeCommentsFromResults: true,
          onlyCurrentFiletype: false,
        },
        file_external: {
          cmd: ["fd", ".", "-H", "-E", ".git", "-t", "f"],
        },
      },
      sourceOptions: {
        "_": {
          matchers: ["matcher_multi_regex"],
          ignoreCase: true,
        },
      },
      filterParams: {
        matcher_multi_regex: {
          highlightMatched: "Search",
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
        },
        lsp: {
          defaultAction: "open",
        },
        help: {
          defaultAction: "open",
        },
        action: {
          defaultAction: "do",
        },
        word: {
          defaultAction: "append",
        },
        ui_select: {
          defaultAction: "select",
        },
        lsp_codeAction: {
          defaultAction: "apply",
        },
        quickfix_history: {
          defaultAction: "open",
        },
      },
    });

    // Live grep
    args.contextBuilder.patchLocal("grep", {
      sources: [{ name: "rg" }],
      sourceParams: {
        rg: {
          inputType: "migemo",
          args: [
            "--json",
            "--ignore-case",
            "--hidden",
            "--glob",
            "!.git",
          ],
        },
      },
      sourceOptions: {
        rg: {
          matchers: [],
          volatile: true,
        },
      },
    });

    // Filter
    args.contextBuilder.patchLocal("filer", {
      ui: "filer",
      sync: true,
      sources: [{ name: "file" }],
      sourceOptions: {
        file: {
          sorters: ["sorter_alpha"],
          columns: ["icon_filename"],
        },
      },
      actionOptions: {
        narrow: {
          quit: true,
        },
      },
    });
  }
}
