-- 24bitカラー
vim.opt.termguicolors = true

-- intro を非表示
vim.opt.shortmess = 'I'

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

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- ヒストリの上限
vim.opt.history = 255

-- LSPの警告フォーマット
-- ref: https://dev.classmethod.jp/articles/eetann-change-neovim-lsp-diagnostics-format/
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})

-- Terminalを現在のウィンドウの下部に開く
vim.api.nvim_create_user_command('T', 'split | wincmd j | resize 10 | terminal <args>', { nargs = '*' })
