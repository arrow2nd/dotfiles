local opt = vim.opt

-- 文字
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

-- 24bitカラー
opt.termguicolors = true

-- statusline を下部に固定
opt.laststatus = 3

-- intro を非表示
opt.shortmess = 'I'

-- 行
opt.number = false
opt.signcolumn = 'yes'
opt.cursorline = true

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
opt.listchars = { tab = '>>', trail = '-', nbsp = '+' }

-- タブ, インデント
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- ヒストリの上限
opt.history = 512

-- 補完
opt.completeopt = 'menuone,noinsert'

-- LSPの警告フォーマット
-- ref: https://dev.classmethod.jp/articles/eetann-change-neovim-lsp-diagnostics-format/
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    format = function(diagnostic)
      return string.format('%s (%s: %s)', diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})

-- 自動フォーマットを無視して保存
vim.api.nvim_create_user_command('W', 'noautocmd w', {})
