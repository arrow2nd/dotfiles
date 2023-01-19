local h = require("util.helper")

local common_on_attach = function(client, bufnr)
  h.nmap("K", "<CMD>lua vim.lsp.buf.hover()<CR>")
  h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>")
  h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>")
  h.nmap("g]", "<CMD>lua vim.diagnostic.goto_next()<CR>")
  h.nmap("g[", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
  h.nmap("ga", "<CMD>lua vim.lsp.buf.code_action()<CR>", { desc = "Show available code actions" })
  h.nmap("gE", "<CMD>Telescope diagnostics<CR>")
  h.nmap("gr", "<CMD>Telescope lsp_references<CR>", { desc = "Lists all the references" })
  h.nmap("gi", "<CMD>Telescope lsp_implementations<CR>", { desc = "Lists all the implementations" })
  h.nmap("gd", "<CMD>Telescope lsp_definitions<CR>", { desc = "Lists all the definitions" })
  h.nmap("gt", "<CMD>Telescope lsp_type_definitions<CR>", { desc = "Lists all the type definitions" })

  local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

  -- 保存時に自動でフォーマット
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
      end,
      group = augroup,
      buffer = bufnr,
    })
  end
end

local disable_fmt_on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  common_on_attach(client, bufnr)
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      require("mason-lspconfig").setup_handlers({ function(server)
        local buf_full_filename = vim.api.nvim_buf_get_name(0)
        local node_root_dir = lspconfig.util.root_pattern("package.json")
        local is_node_repo = node_root_dir(buf_full_filename) ~= nil

        local opts = {
          on_attach = common_on_attach,
          capabilities = cmp_nvim_lsp.default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }

        -- denols と tsserver を出し分ける
        -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
        if server == "denols" then
          if is_node_repo then return end
          opts.cmd = { "deno", "lsp", "--unstable" }
          opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
          opts.init_options = { lint = true, unstable = true }
        elseif server == "tsserver" then
          if not is_node_repo then return end
          opts.root_dir = node_root_dir
          opts.on_attach = disable_fmt_on_attach
        elseif server == "tailwindcss" then
          local tailwind_root_dir = lspconfig.util.root_pattern("tailwind.config.[jt]s", "twind.config.[jt]s")
          if tailwind_root_dir(buf_full_filename) == nil then return end
        elseif server == "jsonls" then
          opts.on_attach = disable_fmt_on_attach
        end

        lspconfig[server].setup(opts)
      end })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = {
      ensure_installed = {
        "denols",
        "gopls",
        "tsserver",
        "sumneko_lua",
        "eslint",
        "yamlls",
        "jsonls",
        "rust_analyzer",
        "tailwindcss",
        "cssls",
        "bashls",
      },
      automatic_installation = true,
    }
  },
  {
    "williamboman/mason.nvim",
    config = {
      ui = {
        icons = {
          package_installed = "",
          package_pending = "↻",
          package_uninstalled = ""
        }
      }
    }
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.textlint.with {
            filetypes = { "markdown" },
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return utils.has_file({ ".textlintrc", ".textlintrc.yml", ".textlintrc.json" })
            end,
          },
        },
        on_attach = common_on_attach,
        capabilities = cmp_nvim_lsp.default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        ),
        diagnostics_format = "#{m} (#{s}: #{c})",
      })
    end
  }
}
