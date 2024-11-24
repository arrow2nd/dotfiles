local api = vim.api
local augroup = api.nvim_create_augroup("AutoCommands", {})

-- rdfをxmlとして読む
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = augroup,
	pattern = { "*.rdf" },
	callback = function()
		vim.opt.filetype = "xml."

		local full_path = vim.fn.expand("%:p")
		if string.find(full_path, "imasparql") then
			vim.opt.filetype:append("imasrdf")
		else
			vim.opt.filetype:append("rdf")
		end
	end,
})

-- mdxをmdとして読む
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.mdx",
	command = "set filetype=markdown.mdx",
})

-- 常にインサートモードでTerminalを開く
-- ref: https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal
api.nvim_create_autocmd({ "TermOpen" }, {
	group = augroup,
	pattern = { "term://*" },
	command = "startinsert",
})

-- LSPからの進行状況を受け取ったらステータスを更新する
api.nvim_create_autocmd("LspProgress", {
	group = augroup,
	pattern = "*",
	command = "redrawstatus",
})
