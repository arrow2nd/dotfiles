local h = require("util.helper")

local reset_ui = function()
	local top = 1
	local width = vim.opt.columns:get()
	local height = vim.opt.lines:get()
	local win_width = math.floor(width * 0.8)
	local win_height = math.floor(height * 0.8)

	vim.fn["ddu#custom#patch_global"]({
		ui = "ff",
		uiParams = {
			_ = {
				winWidth = win_width,
				winHeight = win_height,
				winCol = math.floor((width - win_width) / 2),
				winRow = top,
				split = "floating",
				floatingBorder = "single",
				preview = true,
				previewFloating = true,
				previewFloatingBorder = "single",
				previewSplit = "vertical",
				previewWidth = math.floor(win_width * 0.5),
				previewHeight = win_height - 2,
				previewCol = math.floor(width / 2) - 2,
				previewRow = top + 1,
			},
			ff = {
				autoResize = false,
				ignoreEmpty = false,
			},
			filer = {},
		},
	})
end

vim.fn["ddu#custom#load_config"](vim.fn.expand("~/.config/nvim/ts/ddu.ts"))

reset_ui()

-- 幅を再計算するために画面がリサイズされたら再設定する
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*",
	callback = reset_ui,
})

h.nmap(";f", "<Cmd>Ddu file_external<CR>")
h.nmap(";h", "<Cmd>Ddu help<CR>")
h.nmap(";B", "<Cmd>Ddu buffer<CR>")
h.nmap(";o", "<Cmd>Ddu file_old<CR>")
h.nmap(";r", "<Cmd>Ddu register<CR>")
h.nmap(";g", "<Cmd>Ddu -name=grep<CR>")
h.nmap(";T", "<Cmd>Todo<CR>")
h.nmap(";F", "<Cmd>Fixme<CR>")
h.nmap(";b", [[<Cmd>Ddu -name=filer -searchPath=`expand('%:p')`<CR>]])
h.nmap(";q", "<Cmd>Ddu quickfix_history<CR>")
h.nmap("<Leader>gg", "<Cmd>Ddu git_status<CR>")
h.nmap("<Leader>gs", "<Cmd>Ddu git_stash<CR>")
h.nmap("<Leader>gl", "<Cmd>Ddu git_log<CR>")
h.nmap("<Leader>gb", "<Cmd>Ddu git_branch<CR>")
h.nmap("gE", "<CMD>Ddu lsp_diagnostic -unique<CR>", { desc = "Lists all the diagnostics" })
h.nmap("gD", "<Cmd>Ddu anyjump_definition -ui=ff<CR>")
h.nmap("gR", "<Cmd>Ddu anyjump_reference -ui=ff<CR>")

local opts = { buffer = true, silent = true, noremap = true }
local nowait = { buffer = true, silent = true, noremap = true, nowait = true }

local common_keymaps = function()
	vim.wo.cursorline = true

	-- 開く
	h.nmap("<CR>", '<Cmd>call ddu#ui#do_action("itemAction")<CR>', opts)

	-- 分割して開く
	h.nmap("os", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "split"}})<CR>', opts)
	h.nmap(
		"ov",
		'<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "vsplit"}})<CR>',
		opts
	)

	-- 選択
	h.nmap("<SPACE>", '<Cmd>call ddu#ui#do_action("toggleSelectItem")<CR>', opts)
	h.nmap("a", '<Cmd>call ddu#ui#do_action("toggleAllItems")<CR>', opts)

	-- 閉じる
	h.nmap("<ESC>", '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)
	h.nmap("q", '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)

	-- アクション選択
	h.nmap("<C-CR>", '<Cmd>call ddu#ui#do_action("chooseAction")<CR>', opts)

	-- プレビュー
	h.nmap("K", '<Cmd>call ddu#ui#do_action("togglePreview")<CR><Cmd>stopinsert<CR>', opts)
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ddu-ff",
	callback = function()
		common_keymaps()

		-- フィルターにフォーカス
		h.nmap("i", '<Cmd>call ddu#ui#do_action("openFilterWindow")<CR>', opts)

		-- 一括でQuickfixに流しこむ
		h.nmap("<C-q>", function()
			vim.fn["ddu#ui#multi_actions"]({
				{ "clearSelectAllItems" },
				{ "toggleAllItems" },
				{ "itemAction", { name = "quickfix" } },
			})
		end, opts)

		-- git_status
		h.nmap("s", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "add"})<CR>', opts)
		h.nmap("u", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "reset"})<CR>', opts)
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "ddu-filer",
	callback = function()
		common_keymaps()

		-- ファイル操作
		h.nmap("y", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "copy"})<CR>', opts)
		h.nmap("p", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "paste"})<CR>', opts)
		h.nmap("d", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "delete"})<CR>', opts)
		h.nmap("r", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "rename"})<CR>', opts)
		h.nmap("m", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "move"})<CR>', opts)
		h.nmap("c", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "newFile"})<CR>', opts)
		h.nmap("C", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "newDirectory"})<CR>', opts)

		-- ディレクトリなら展開、ファイルなら何もしない
		vim.cmd([[nnoremap <buffer><expr> <Tab>
             \ ddu#ui#get_item()->get('isTree', v:false)
             \ ? "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
             \ : "<Tab>"]])

		-- ディレクトリなら展開、ファイルなら開く
		vim.cmd([[nnoremap <buffer><expr> <CR>
             \ ddu#ui#get_item()->get('isTree', v:false)
             \ ? "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
             \ : "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open'})<CR>"]])
	end,
})
