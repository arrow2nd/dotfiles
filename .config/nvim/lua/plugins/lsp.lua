local h = require("util.helper")
local fs = require("util.fs")
local lsp = require("util.lsp")

local efm_opts = function()
  local rootMarkers = {
    prettier = {
      ".prettierrc",
      ".prettierrc.js",
      ".prettierrc.mjs",
      ".prettierrc.cjs",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettierrc.json",
      ".prettierrc.json5",
      ".prettierrc.toml",
    },
    biome = {
      "biome.json",
    },
    stylua = {
      "stylua.toml",
      ".stylua.toml",
    },
    textlint = {
      ".textlintrc",
      ".textlintrc.yml",
      ".textlintrc.yaml",
      ".textlintrc.json",
    },
  }

  local prettier = {
    formatCommand = "node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
    formatStdin = true,
    rootMarkers = rootMarkers.prettier,
  }

  local denofmt = {
    formatCommand = "deno fmt --ext ${FILEEXT} -",
    formatStdin = true,
  }

  local javascriptFormatter

  if fs.has_file(rootMarkers.biome) then
    -- Biome の設定ファイルがあればすべて無効
    javascriptFormatter = nil
  else
    -- prettierrc があれば Prettier を なければ denofmt を使う
    javascriptFormatter = fs.has_file(rootMarkers.prettier) and prettier or denofmt
  end

  local stylua = {
    formatCommand = "stylua --color Never -",
    formatStdin = true,
    rootMarkers = rootMarkers.stylua,
  }

  local textlint = {
    lintCommand = "node_modules/.bin/textlint --no-color --format compact --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {
      "%.%#: line %l, col %c, %trror - %m",
      "%.%#: line %l, col %c, %tarning - %m",
    },
    rootMarkers = rootMarkers.textlint,
  }

  local languages = {
    html = { prettier },
    css = { prettier },
    scss = { prettier },
    javascript = { javascriptFormatter },
    javascriptreact = { javascriptFormatter },
    typescript = { javascriptFormatter },
    typescriptreact = { javascriptFormatter },
    json = { javascriptFormatter },
    jsonc = { javascriptFormatter },
    yaml = { prettier },
    markdown = { javascriptFormatter, textlint },
    lua = { stylua },
  }

  return {
    init_options = {
      documentFormatting = true,
      hover = true,
      codeAction = true,
    },
    filetypes = vim.tbl_keys(languages),
    settings = { languages = languages },
  }
end

return {
  {
    "tekumara/typos-lsp",
    build = "cargo build --release",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(spec)
      local Path = require("plenary.path")
      local dir = spec.dir

      local BIN_DIR = Path:new(dir, "target", "release")
      vim.env.PATH = BIN_DIR:absolute() .. ":" .. vim.env.PATH
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "tekumara/typos-lsp",
      "lsp_node_servers",
      "uga-rosa/ddc-source-lsp-setup",
      "Shougo/ddc-source-lsp",
    },
    init = function()
      -- global keymaps
      h.nmap("gE", "<CMD>Ddu lsp_diagnostic -unique<CR>", { desc = "Lists all the diagnostics" })
      h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
      h.nmap("]g", "<CMD>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })
      h.nmap("[g", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function()
          -- local keymaps
          h.nmap("K", "<CMD>lua vim.lsp.buf.hover()<CR>", { desc = "Show hover" })
          h.nmap("gf", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Formatting" })
          h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename definition" })
          h.nmap("ga", "<CMD>Ddu lsp_codeAction -unique<CR>", { desc = "Show available code actions" })
          h.nmap("gd", "<CMD>Ddu lsp_definition<CR>", { desc = "Lists all the definition" })
          h.nmap("gr", "<CMD>Ddu lsp_references -unique<CR>", { desc = "Lists all the references" })
        end,
      })
    end,
    config = function()
      -- ポップアップウィンドウのボーダースタイルを設定
      require("lspconfig.ui.windows").default_options.border = "single"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
      vim.diagnostic.config({
        float = {
          border = "single",
        },
      })

      --  client_capabilities と forceCompletionPattern を設定
      require("ddc_source_lsp_setup").setup()

      local lspconfig = require("lspconfig")
      local buf_full_filename = vim.api.nvim_buf_get_name(0)

      -- efm
      lspconfig.efm.setup(vim.tbl_deep_extend("force", {
        on_attach = lsp.enable_fmt_on_attach,
      }, efm_opts()))

      -- JavaScript / TypeScript
      local node_root_dir = lspconfig.util.root_pattern("package.json")
      local is_node_dir = node_root_dir(buf_full_filename) ~= nil

      local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
      local is_deno_dir = deno_root_dir(buf_full_filename) ~= nil

      if is_deno_dir then
        -- Deno LSPのcodefencesを適切にハイライトするため
        vim.g.markdown_fenced_languages = {
          "ts=typescript",
        }

        -- Deno
        lspconfig.denols.setup({
          cmd = {
            "deno",
            "lsp",
          },
          init_options = {
            lint = true,
            unstable = true,
          },
          on_attach = lsp.disable_fmt_on_attach,
        })
      elseif is_node_dir then
        -- Node.js
        lspconfig.tsserver.setup({
          -- NOTE:
          -- bun run --bun するとめちゃ早いけどめちゃメモリ喰った
          -- Node : 200 - 400MB
          -- bun : 350 - 600MB
          on_attach = lsp.disable_fmt_on_attach,
        })
      end

      -- Golang
      lspconfig.gopls.setup({
        on_attach = lsp.enable_fmt_on_attach,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        on_attach = lsp.disable_fmt_on_attach,
      })

      -- Angular
      lspconfig.angularls.setup({})

      -- Astro
      lspconfig.astro.setup({})

      -- ESLint
      lspconfig.eslint.setup({})

      -- biome
      lspconfig.biome.setup({
        cmd = {
          "node_modules/.bin/biome",
          "lsp-proxy",
        },
      })

      -- HTML
      lspconfig.html.setup({
        on_attach = lsp.disable_fmt_on_attach,
      })

      -- CSS
      lspconfig.cssls.setup({
        filetypes = { "css", "scss", "sass", "less" },
      })

      -- JSON
      lspconfig.jsonls.setup({
        cmd = { "vscode-json-language-server", "--stdio" },
        on_attach = lsp.disable_fmt_on_attach,
      })

      -- YAML
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      })

      -- typos LSP
      lspconfig.typos_lsp.setup({
        init_options = {
          config = "~/.config/typos/.typos.toml",
          diagnosticSeverity = "Hint",
        },
      })
    end,
  },
}
