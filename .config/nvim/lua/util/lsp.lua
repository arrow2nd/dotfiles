local M = {}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- 保存時に自動フォーマット
M.on_attach_with_enable_format = function(client, bufnr)
  if client:supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({
      group = augroup,
      buffer = bufnr,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        vim.lsp.buf.format({
          async = false,
          timeout_ms = 5000,
        })
      end,
      group = augroup,
      buffer = bufnr,
    })
  end
end

-- 共通のon_init
M.on_init = function(client, _)
  if client.server_capabilities then
    -- Semantic token を有効にすると色がいっぱいになるので切る
    client.server_capabilities.semanticTokensProvider = false
  end
end

return M
