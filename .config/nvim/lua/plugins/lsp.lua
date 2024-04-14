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
    -- Biome の設定があればすべて無効
    javascriptFormatter = nil
  else
    -- Prettier の設定がなければ denofmt を使う
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
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "lsp_node_servers",
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
      vim.diagnostic.config({ float = { border = "single" } })

      local lspconfig = require("lspconfig")
      local ddc_source_lsp = require("ddc_source_lsp")
      local buf_full_filename = vim.api.nvim_buf_get_name(0)

      -- efm
      lspconfig.efm.setup(vim.tbl_deep_extend("force", {
        capabilities = ddc_source_lsp.make_client_capabilities(),
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
          capabilities = ddc_source_lsp.make_client_capabilities(),
          on_attach = lsp.disable_fmt_on_attach,
        })
      elseif is_node_dir then
        -- Node.js
        lspconfig.tsserver.setup({
          -- NOTE: bun run --bun するとめちゃ早いけどめちゃメモリ喰った
          cmd = { "typescript-language-server", "--stdio" },
          on_attach = lsp.disable_fmt_on_attach,
        })
      end

      -- Golang
      lspconfig.gopls.setup({
        capabilities = ddc_source_lsp.make_client_capabilities(),
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

      -- Tailwind CSS
      lspconfig.tailwindcss.setup({})

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

      -- emmet LSP
      lspconfig.emmet_language_server.setup({
        filetypes = { "html", "css", "scss", "sass", "less" },
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
