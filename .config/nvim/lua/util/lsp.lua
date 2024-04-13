local M = {}

-- 自動フォーマットを有効にできるか
--
-- 環境変数 `NVIM_DISABLE_AUTOFORMATTING_PROJECTS` にプロジェクトのパスを追加することで無効にできます
-- カンマ区切りで複数指定可能です
local enable_autoformat = function()
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

local common_on_attach = function(client, _)
  -- Semantic token を有効にすると色がいっぱいになるので切る
  client.server_capabilities.semanticTokensProvider = nil
end

-- 自動フォーマットを有効
M.enable_fmt_on_attach = function(client, bufnr)
  common_on_attach(client, bufnr)

  -- 保存時に自動フォーマット
  if client.supports_method("textDocument/formatting") and enable_autoformat() then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {
      clear = false,
    })

    vim.api.nvim_clear_autocmds({
      group = augroup,
      buffer = bufnr,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          timeout_ms = 5000,
        })
      end,
      group = augroup,
      buffer = bufnr,
    })
  end
end

-- 自動フォーマットを無効
M.disable_fmt_on_attach = function(client, bufnr)
  common_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
end

return M
