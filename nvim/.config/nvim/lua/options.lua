-- 不要なプラグインを無効化
local disable_plugins = {
  'did_install_default_menus',
  'did_install_syntax_menu',
  'did_indent_on',
  'did_load_filetypes',
  'did_load_ftplugin',
  'loaded_2html_plugin',
  'loaded_gzip',
  'loaded_man',
  'loaded_matchit',
  'loaded_matchparen',
  'loaded_netrwPlugin',
  'loaded_remote_plugins',
  'loaded_shada_plugin',
  'loaded_spellfile_plugin',
  'loaded_tarPlugin',
  'loaded_tutor_mode_plugin',
  'loaded_zipPlugin',
  'skip_loading_mswin',
}

for _, name in ipairs(disable_plugins) do
  vim.g[name] = 1
end

-- 24bitカラー
vim.opt.termguicolors = true

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
-- NOTE: Win / WSL で起動時間の妨げになる & たいして使わないので mac のみにしてる
if (vim.fn.has('mac') == 1) then
  vim.opt.clipboard = 'unnamedplus'
end

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

-- ヒストリの上限
vim.opt.history = 255
