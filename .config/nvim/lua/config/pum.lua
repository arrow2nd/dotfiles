local h = require("util.helper")

vim.fn["pum#set_option"]({
	auto_select = true,
	padding = true,
	border = "single",
	preview = true,
	preview_border = "single",
	preview_delay = 250,
	preview_width = 72,
	scrollbar_char = "▋",
	highlight_normal_menu = "Normal",
	offset_cmdcol = 1,
	offset_cmdrow = 2,
})

local opts = {
	silent = true,
	noremap = true,
}

-- Insert
h.imap("<C-n>", "<cmd>call pum#map#select_relative(+1)<CR>", opts)
h.imap("<C-p>", "<cmd>call pum#map#select_relative(-1)<CR>", opts)
h.imap("<C-y>", "<cmd>call pum#map#confirm()<CR>", opts)
h.imap("<C-e>", "<cmd>call pum#map#cancel()<CR>", opts)

-- コマンドライン
h.cmap("<C-n>", "<cmd>call pum#map#insert_relative(+1)<CR>", { noremap = true })
h.cmap("<C-p>", "<cmd>call pum#map#insert_relative(-1)<CR>", { noremap = true })
h.cmap("<C-y>", "<cmd>call pum#map#confirm()<CR>", { noremap = true })
h.cmap("<C-e>", "<cmd>call pum#map#cancel()<CR>", { noremap = true })
