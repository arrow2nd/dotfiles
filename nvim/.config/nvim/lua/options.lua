-- 24bitカラー
vim. opt.termguicolors = true

-- 行
vim.opt.number = true
vim.opt.signcolumn = 'yes'

-- ヘルプの言語
vim.opt.helplang = 'ja'

-- バックアップ, スワップファイル
vim.opt.backup = false
vim.opt.swapfile = false

-- buffer切り替え時の未保存警告をオフ
vim.opt.hidden = true

-- 行末までカーソルを移動可能に
vim.opt.virtualedit = 'onemore'

-- マウス操作有効化
vim.opt.mouse = 'a'

-- タブ, インデント
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

-- 全ての値を10進数として扱う
vim.opt.nrformats = ''

-- ヤンクした内容をクリップボードへ
vim.opt.clipboard:append('unnamedplus')

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- ヒストリの上限
vim.opt.history = 255

