local M = {}

local common_on_attach = function(client, _)
	-- Semantic token を有効にすると色がいっぱいになるので切る
	client.server_capabilities.semanticTokensProvider = nil
end

-- 自動フォーマットを有効
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.enable_fmt_on_attach = function(client, bufnr)
	common_on_attach(client, bufnr)

	-- 保存時に自動フォーマット
	if client.supports_method("textDocument/formatting") then
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

-- 自動フォーマットを無効
M.disable_fmt_on_attach = function(client, bufnr)
	common_on_attach(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
end

return M
