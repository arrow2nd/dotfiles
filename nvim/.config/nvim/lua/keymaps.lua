local helper = require('helper')

vim.g.mapleader = " "

helper.imap('jj', '<ESC>')

-- バッファ切り替え
helper.nmap('<C-j>', '<CMD>bprev<CR>')
helper.nmap('<C-k>', '<CMD>bnext<CR>')

-- ハイライト解除
helper.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>')

-- ヒストリ選択
helper.cmap('<C-p>', '<Up>')
helper.cmap('<C-n>', '<Down>')

-- vim-fugitive
helper.nmap('<Leader>gs', '<CMD>Git<CR>')
helper.nmap('<Leader>gc', '<CMD>Git commit<CR>')
helper.nmap('<Leader>gb', '<CMD>Git blame<CR>')
helper.nmap('<Leader>gd', '<CMD>Gdiffsplit<CR>')
helper.nmap('<Leader>gl', '<CMD>Gclog<CR>')

-- translate.vim
helper.vmap('t', '<Plug>(Translate)')
