local h = require('helper')

-- リーダーキー
vim.g.mapleader = " "

-- ESC
h.imap('jj', '<ESC>')

-- バッファ切り替え
h.nmap('<C-j>', '<CMD>bprev<CR>')
h.nmap('<C-k>', '<CMD>bnext<CR>')

-- ハイライト解除
h.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>')

-- ヒストリ選択
h.omap('<C-p>', '<Up>')
h.omap('<C-n>', '<Down>')

-- telescope.vim
h.nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
h.nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
h.nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
h.nmap('<C-n>', function()
  return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand("%:p:h") .. '<CR>'
end, { silent = true, expr = true })

-- gin.vim
h.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>')
h.nmap('<Leader>gl', '<CMD>GinBuffer ++opener=split log<CR>')
h.nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>')
h.nmap('<Leader>gc', '<CMD>Gin commit -v<CR>')
h.nmap('<Leader>gp', '<CMD>GinPatch ++opener=vsplit<CR>')

-- translate.vim
h.vmap('t', '<Plug>(Translate)')