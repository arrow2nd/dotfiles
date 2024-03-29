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
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Shougo/ddc-source-lsp",
    },
    config = function()
      -- ポップアップウィンドウのボーダースタイルを設定
      require("lspconfig.ui.windows").default_options.border = "single"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
      vim.diagnostic.config({ float = { border = "single" } })

      require("mason").setup()
      require("mason-lspconfig").setup()

      local lspconfig = require("lspconfig")
      local ddc_source_lsp = require("ddc_source_lsp")

      require("mason-lspconfig").setup_handlers({
        function(server)
          local buf_full_filename = vim.api.nvim_buf_get_name(0)

          local opts = {
            capabilities = ddc_source_lsp.make_client_capabilities(),
            on_attach = lsp.enable_fmt_on_attach,
          }

          local node_root_dir = lspconfig.util.root_pattern("package.json")
          local is_node_dir = node_root_dir(buf_full_filename) ~= nil

          local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
          local is_deno_dir = deno_root_dir(buf_full_filename) ~= nil

          -- denols と tsserver を出し分ける
          -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
          if server == "denols" then
            if not is_deno_dir then
              return
            end
            opts.root_dir = deno_root_dir
            opts.cmd = { "deno", "lsp", "--unstable" }
            opts.init_options = { lint = true, unstable = true }
            opts.on_attach = lsp.disable_fmt_on_attach

          -- Node.js
          elseif server == "tsserver" then
            if is_deno_dir or not is_node_dir then
              return
            end
            opts.root_dir = node_root_dir
            opts.on_attach = lsp.disable_fmt_on_attach

          -- css
          elseif server == "cssls" then
            opts.filetypes = { "css", "scss", "sass", "less" }

          -- yaml
          elseif server == "yamlls" then
            opts.settings = {
              yaml = {
                keyOrdering = false,
              },
            }

          -- efm
          elseif server == "efm" then
            opts = vim.tbl_deep_extend("force", opts, efm_opts())

          -- emmet
          elseif server == "emmet_language_server" then
            opts.filetypes = { "html", "css", "scss", "sass", "less" }

          -- typos
          elseif server == "typos_lsp" then
            opts.init_options = {
              config = "~/.config/typos/.typos.toml",
              diagnosticSeverity = "Hint",
            }

          -- 内蔵フォーマッタを無効化
          elseif server == "html" or server == "jsonls" or server == "lua_ls" then
            opts.on_attach = lsp.disable_fmt_on_attach
          end

          lspconfig[server].setup(opts)
        end,
      })

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
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = {
      ensure_installed = {
        "astro",
        "efm",
        "denols",
        "gopls",
        "tsserver",
        "lua_ls",
        "yamlls",
        "jsonls",
        "rust_analyzer",
        "cssls",
        "eslint",
        "biome",
        "emmet_language_server",
        "typos_lsp",
      },
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason.nvim",
    config = {
      ui = {
        border = "single",
        icons = {
          package_installed = " ",
          package_pending = "↻ ",
          package_uninstalled = " ",
        },
      },
    },
  },
}
