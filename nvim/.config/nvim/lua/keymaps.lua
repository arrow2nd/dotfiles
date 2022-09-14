local helper = require('helper')

vim.g.mapleader = " "

helper.imap('jj', '<ESC>')

-- バッファ切り替え
helper.nmap('<C-j>', '<CMD>bprev<CR>')
helper.nmap('<C-k>', '<CMD>bnext<CR>')

-- ハイライト解除
helper.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>')

-- ヒストリ選択
helper.omap('<C-p>', '<Up>')
helper.omap('<C-n>', '<Down>')

-- telescope.vim
helper.nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
helper.nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
helper.nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
helper.nmap('<C-n>', function ()
  return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand("%:p:h") .. '<CR>'
end, { silent = true, expr = true })

-- gin.vim
helper.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>')
helper.nmap('<Leader>gl', '<CMD>GinBuffer ++opener=split log<CR>')
helper.nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>')
helper.nmap('<Leader>gc', '<CMD>Gin commit -v<CR>')
helper.nmap('<Leader>gp', '<CMD>GinPatch ++opener=vsplit<CR>')

-- translate.vim
helper.vmap('t', '<Plug>(Translate)')
