local fs = require("util.fs")
local lsp = require("util.lsp")

return {
  {
    "mattn/efm-langserver",
    event = "BufReadPre",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local config_file = {
        prettier = {
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.js",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.mjs",
          ".prettierrc.cjs",
          ".prettierrc.toml",
        },
        deno = {
          "deno.json",
          "deno.jsonc",
        },
        stylua = {
          "stylua.toml",
          ".stylua.toml",
        },
        textlint = {
          ".textlintrc",
          ".textlintrc.yml",
          ".textlintrc.json",
        },
      }

      local prettier = {
        formatCommand = "node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
        formatStdin = true,
        rootMarkers = config_file.prettier,
      }

      local denofmt = {
        formatCommand = "deno fmt --ext ${FILEEXT} -",
        formatStdin = true,
      }

      local denofmt_or_prettier = fs.has_file(config_file.prettier) and prettier or denofmt

      local stylua = {
        formatCommand = "stylua --color Never -",
        formatStdin = true,
        rootMarkers = config_file.stylua,
      }

      local textlint = {
        lintCommand = "node_modules/.bin/textlint --no-color --format compact --stdin --stdin-filename ${INPUT}",
        lintStdin = true,
        lintFormats = { "%.%#: line %l, col %c, %trror - %m", "%.%#: line %l, col %c, %tarning - %m" },
        rootMarkers = config_file.textlint,
      }

      local languages = {
        css = { prettier },
        html = { prettier },
        javascript = { denofmt_or_prettier },
        javascriptreact = { denofmt_or_prettier },
        json = { denofmt_or_prettier },
        jsonc = { denofmt_or_prettier },
        lua = { stylua },
        markdown = { denofmt_or_prettier, textlint },
        scss = { prettier },
        typescript = { denofmt_or_prettier },
        typescriptreact = { denofmt_or_prettier },
        yaml = { prettier },
      }

      require("lspconfig").efm.setup({
        init_options = { documentFormatting = true },
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { vim.uv.cwd() },
          languages = languages,
        },
        on_attach = lsp.enable_fmt_on_attach,
      })
    end,
  },
}
