local opt = vim.opt

-- 文字コード
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- 24bitカラー
opt.termguicolors = true

-- intro を非表示
opt.shortmess = 'I'

-- 行
opt.number = false
opt.signcolumn = 'yes'

-- ヘルプの言語
opt.helplang = 'ja'

-- バックアップ, スワップファイル
opt.backup = false
opt.swapfile = false

-- buffer切り替え時の未保存警告をオフ
opt.hidden = true

-- 行末までカーソルを移動可能に
opt.virtualedit = 'onemore'

-- マウス操作有効化
opt.mouse = 'a'

-- 不可視文字可視化
opt.list = true
opt.listchars = { tab = '<->', trail = '-', nbsp = '+' }

-- タブ, インデント
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true

-- 全ての値を10進数として扱う
opt.nrformats = ''

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- ヒストリの上限
opt.history = 255

-- LSPの警告フォーマット
-- ref: https://dev.classmethod.jp/articles/eetann-change-neovim-lsp-diagnostics-format/
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    format = function(diagnostic)
      return string.format('%s (%s: %s)', diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})

-- Terminalを現在のウィンドウの下部に開く
vim.api.nvim_create_user_command('T', 'split | wincmd j | resize 10 | terminal <args>', { nargs = '*' })
