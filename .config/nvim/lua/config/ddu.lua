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

-- いろいろ
h.nmap(";f", ":Ddu file_external<CR>")
h.nmap(";h", ":Ddu help<CR>")
h.nmap(";B", ":Ddu buffer<CR>")
h.nmap(";o", ":Ddu file_old<CR>")
h.nmap(";r", ":Ddu register<CR>")
h.nmap(";q", ":Ddu quickfix_history<CR>")

-- git
h.nmap("<Leader>gg", ":Ddu git_status -name=git_status<CR>")

-- grep
h.nmap(";g", ":Ddu -name=grep<CR>")
h.nmap(";G", ':execute "Ddu -name=grep -input=" . expand("<cword>")<CR>')

-- ファイラー
h.nmap(";b", [[:Ddu -name=filer -searchPath=`expand('%:p')`<CR>]])

-- lsp
h.nmap("gE", ":Ddu lsp_diagnostic -unique<CR>", { desc = "Lists all the diagnostics" })
h.nmap("gD", ":Ddu anyjump_definition -ui=ff<CR>")
h.nmap("gR", ":Ddu anyjump_reference -ui=ff<CR>")

local opts = {
  buffer = true,
  silent = true,
  noremap = true,
}

local nowait = {
  buffer = true,
  silent = true,
  noremap = true,
  nowait = true,
}

local common_keymaps = function()
  vim.wo.cursorline = true

  -- 開く
  h.nmap("<CR>", ':call ddu#ui#do_action("itemAction")<CR>', opts)

  -- 分割して開く
  h.nmap("os", ':call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "split"}})<CR>', opts)
  h.nmap("ov", ':call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "vsplit"}})<CR>', opts)

  -- 全選択
  h.nmap("<Space>a", ':call ddu#ui#do_action("toggleAllItems")<CR>', opts)
  -- 1つだけ選択
  h.nmap("<Space><Space>", ':call ddu#ui#do_action("toggleSelectItem")<CR>j', opts)
  -- 複数選択
  h.xmap("<Space><Space>", ':call ddu#ui#do_action("toggleSelectItem")<CR>', opts)

  -- 閉じる
  h.nmap("q", ':call ddu#ui#do_action("quit")<CR>', nowait)

  -- アクション選択
  h.nmap("a", ':call ddu#ui#do_action("chooseAction")<CR>', opts)

  -- プレビュー
  h.nmap("K", ':call ddu#ui#do_action("togglePreview")<CR>:stopinsert<CR>', opts)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-ff",
  callback = function()
    common_keymaps()

    -- フィルターにフォーカス
    h.nmap("i", ':call ddu#ui#do_action("openFilterWindow")<CR>', opts)

    -- 一括でQuickfixに流しこむ
    h.nmap("<C-q>", function()
      vim.fn["ddu#ui#multi_actions"]({
        { "clearSelectAllItems" },
        { "toggleAllItems" },
        { "itemAction", { name = "quickfix" } },
      })
    end, opts)

    -- git_status
    if vim.b.ddu_ui_name == "git_status" then
      h.nmap("<<", ':call ddu#ui#do_action("itemAction", {"name": "add"})<CR>', opts)
      h.xmap("<<", ':call ddu#ui#do_action("itemAction", {"name": "add"})<CR>', opts)
      h.nmap(">>", ':call ddu#ui#do_action("itemAction", {"name": "reset"})<CR>', opts)
      h.xmap(">>", ':call ddu#ui#do_action("itemAction", {"name": "reset"})<CR>', opts)
      h.nmap("X", ':call ddu#ui#do_action("itemAction", {"name": "restore"})<CR>', opts)
      h.xmap("X", ':call ddu#ui#do_action("itemAction", {"name": "restore"})<CR>', opts)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-filer",
  callback = function()
    common_keymaps()

    -- ファイル操作
    h.nmap("y", ':call ddu#ui#do_action("itemAction", {"name": "copy"})<CR>', opts)
    h.nmap("Y", ':call ddu#ui#do_action("itemAction", {"name": "yank"})<CR>', opts)
    h.nmap("p", ':call ddu#ui#do_action("itemAction", {"name": "paste"})<CR>', opts)
    h.nmap("d", ':call ddu#ui#do_action("itemAction", {"name": "delete"})<CR>', opts)
    h.nmap("r", ':call ddu#ui#do_action("itemAction", {"name": "rename"})<CR>', opts)
    h.nmap("m", ':call ddu#ui#do_action("itemAction", {"name": "move"})<CR>', opts)
    h.nmap("c", ':call ddu#ui#do_action("itemAction", {"name": "newFile"})<CR>', opts)
    h.nmap("C", ':call ddu#ui#do_action("itemAction", {"name": "newDirectory"})<CR>', opts)

    -- ディレクトリなら展開、ファイルなら何もしない
    vim.cmd([[nnoremap <buffer><expr> <Tab>
             \ ddu#ui#get_item()->get('isTree', v:false)
             \ ? ":call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
             \ : "<Tab>"]])

    -- ディレクトリなら展開、そうでないならアクションを実行
    vim.cmd([[nnoremap <buffer><expr> <CR>
               \ ddu#ui#get_item()->get('isTree', v:false)
               \ ? ":call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
               \ : ":call ddu#ui#do_action('itemAction')<CR>"]])
  end,
})
