local h = require("util.helper")
local fs = require("util.fs")
local lsp = require("util.lsp")

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "Shougo/ddc-source-lsp",
    },
    init = function()
      -- vim辞書がなければダウンロード
      if vim.fn.filereadable("~/.local/share/cspell/vim.txt.gz") ~= 1 then
        local vim_dictionary_url = "https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz"
        io.popen("curl -fsSLo ~/.local/share/cspell/vim.txt.gz --create-dirs " .. vim_dictionary_url)
      end

      -- ユーザー辞書がなければ作成
      if vim.fn.filereadable("~/.local/share/cspell/user.txt") ~= 1 then
        io.popen("mkdir -p ~/.local/share/cspell")
        io.popen("touch ~/.local/share/cspell/user.txt")
      end
    end,
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

          -- denols と tsserver を出し分ける
          -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
          if server == "denols" then
            local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
            if deno_root_dir(buf_full_filename) == nil then
              return
            end
            opts.root_dir = deno_root_dir
            opts.cmd = { "deno", "lsp", "--unstable" }
            opts.init_options = { lint = true, unstable = true }
            opts.on_attach = lsp.disable_fmt_on_attach

          -- Node.js
          elseif server == "tsserver" then
            local node_root_dir = lspconfig.util.root_pattern("package.json")
            if node_root_dir(buf_full_filename) == nil then
              return
            end
            opts.root_dir = node_root_dir
            opts.on_attach = lsp.disable_fmt_on_attach

            -- tailwind
          elseif server == "tailwindcss" then
            local tailwind_root_dir = lspconfig.util.root_pattern("tailwind.config.{js,cjs,ts}", "twind.config.{js,ts}")
            if tailwind_root_dir(buf_full_filename) == nil then
              return
            end
            opts.root_dir = tailwind_root_dir

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

          -- 内蔵フォーマッタを無効化
          elseif server == "html" or server == "jsonls" or server == "lua_ls" then
            opts.on_attach = lsp.disable_fmt_on_attach
          end

          lspconfig[server].setup(opts)
        end,
      })

      -- efm
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
        lintFormats = {
          "%.%#: line %l, col %c, %trror - %m",
          "%.%#: line %l, col %c, %tarning - %m",
        },
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

      -- cspellが実行できるなら追加
      if vim.fn.executable("cspell") then
        languages["="] = {
          {
            lintCommand = "cspell --no-progress --no-summary --no-color --config=~/.config/cspell/cspell.json ${INPUT}",
            lintIgnoreExitCode = true,
            lintFormats = {
              "%f:%l:%c - %m",
              "%f:%l:%c %m",
            },
            lintSeverity = 4, -- hint
          },
        }
      end

      require("lspconfig").efm.setup({
        init_options = { documentFormatting = true },
        filetypes = vim.tbl_keys(languages),
        settings = { languages = languages },
        on_attach = lsp.enable_fmt_on_attach,
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
        "eslint",
        "yamlls",
        "jsonls",
        "rust_analyzer",
        "tailwindcss",
        "cssls",
        "emmet_language_server",
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
