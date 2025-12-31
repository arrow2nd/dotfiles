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

-- quitするときに特殊ウィンドウを一気に閉じる
-- ref: https://zenn.dev/vim_jp/articles/ff6cd224fab0c7
api.nvim_create_autocmd('QuitPre', {
  callback = function()
    -- 現在のウィンドウ番号を取得
    local current_win = vim.api.nvim_get_current_win()
    -- すべてのウィンドウをループして調べる
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      -- カレント以外を調査
      if win ~= current_win then
        local buf = vim.api.nvim_win_get_buf(win)
        -- buftypeが空文字（通常のバッファ）があればループ終了
        if vim.bo[buf].buftype == '' then
          return
        end
      end
    end
    -- ここまで来たらカレント以外がすべて特殊ウィンドウということなので
    -- カレント以外をすべて閉じる
    vim.cmd.only({ bang = true })
    -- この後、ウィンドウ1つの状態でquitが実行されるので、Vimが終了する
  end,
  desc = 'Close all special buffers and quit Neovim',
})
