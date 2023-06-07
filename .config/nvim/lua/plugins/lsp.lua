local h = require("util.helper")

-- 自動フォーマットを有効にできるか
--
-- 環境変数 `NVIM_DISABLE_AUTOFORMATTING_PROJECTS` にプロジェクトのパスを追加することで無効にできます
-- カンマ区切りで複数指定可能です
local function enable_autoformat()
  local root = vim.fn.getcwd(0)
  local disable_projects = vim.split(os.getenv("NVIM_DISABLE_AUTOFORMATTING_PROJECTS") or "", ",")

  -- 無効にするプロジェクトか
  for _, project in ipairs(disable_projects) do
    if root == project then
      return false
    end
  end

  return true
end

local common_on_attach = function(client, bufnr)
  -- Semantic token を有効にすると色がいっぱいになるので切る
  client.server_capabilities.semanticTokensProvider = nil

  -- 保存時に自動フォーマット
  if client.supports_method("textDocument/formatting") and enable_autoformat() then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
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
      require("mason").setup()
      require("mason-lspconfig").setup()

      local lspconfig = require("lspconfig")
      require("mason-lspconfig").setup_handlers({
        function(server)
          -- スニペットを有効に
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          -- node_modules があるか
          local buf_full_filename = vim.api.nvim_buf_get_name(0)
          local node_root_dir = lspconfig.util.root_pattern("package.json")
          local is_node_repo = node_root_dir(buf_full_filename) ~= nil

          local opts = { capabilities = capabilities, on_attach = common_on_attach }

          -- denols と tsserver を出し分ける
          -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
          if server == "denols" then
            if is_node_repo then
              return
            end
            opts.cmd = { "deno", "lsp", "--unstable" }
            opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
            opts.init_options = { lint = true, unstable = true }

          -- Node.js
          elseif server == "tsserver" then
            if not is_node_repo then
              return
            end
            opts.root_dir = node_root_dir
            opts.on_attach = disable_fmt_on_attach

          -- Angular
          elseif server == "angularls" then
            -- tsserverのものを使うので無効にする
            opts.on_attach = function(client, bufnr)
              client.server_capabilities.renameProvider = false
              common_on_attach(client, bufnr)
            end

          -- tailwind
          elseif server == "tailwindcss" then
            local tailwind_root_dir = lspconfig.util.root_pattern("tailwind.config.[jt]s", "twind.config.[jt]s")
            if tailwind_root_dir(buf_full_filename) == nil then
              return
            end

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
            opts.on_attach = disable_fmt_on_attach
          end

          lspconfig[server].setup(opts)
        end,
      })

      -- global keymaps
      h.nmap("gE", "<CMD>Ddu lsp_diagnostic<CR>", { desc = "Lists all the diagnostics" })
      h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
      h.nmap("]g", "<CMD>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })
      h.nmap("[g", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function()
          -- local keymaps
          h.nmap("K", "<CMD>lua vim.lsp.buf.hover()<CR>", { desc = "Show hover" })
          h.nmap("gf", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Formatting" })
          h.nmap("ga", "<CMD>lua vim.lsp.buf.code_action()<CR>", { desc = "Show available code actions" })
          h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename definition" })
          h.nmap("gD", "<CMD>Ddu -name=lsp_declaration<CR>", { desc = "Show declaration" })
          h.nmap("gd", "<CMD>Ddu -name=lsp_definition<CR>", { desc = "Lists all the definition" })
          h.nmap("gr", "<CMD>Ddu lsp_references<CR>", { desc = "Lists all the references" })
        end,
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = {
      ensure_installed = {
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
      },
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason.nvim",
    config = {
      ui = {
        icons = {
          package_installed = "",
          package_pending = "↻",
          package_uninstalled = "",
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- deno fmt と Prettier を出し分ける
          -- ref: https://zenn.dev/nazo6/articles/c2f16b07798bab
          null_ls.builtins.formatting.deno_fmt.with({
            condition = function(utils)
              -- Prettier の設定がない & Deno のプロジェクトでもない
              return not (utils.has_file({ ".prettierrc", ".prettierrc.js", "deno.json", "deno.jsonc" }))
            end,
          }),
          -- Prettier
          null_ls.builtins.formatting.prettier.with({
            condition = function(utils)
              return utils.has_file({ ".prettierrc", ".prettierrc.js" })
            end,
            prefer_local = "node_modules/.bin",
          }),
          -- TextLint
          null_ls.builtins.diagnostics.textlint.with({
            filetypes = { "markdown" },
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return utils.has_file({ ".textlintrc", ".textlintrc.yml", ".textlintrc.json" })
            end,
          }),
          -- Stylua
          null_ls.builtins.formatting.stylua,
        },
        on_attach = common_on_attach,
        diagnostics_format = "#{m} (#{s}: #{c})",
      })
    end,
  },
}
