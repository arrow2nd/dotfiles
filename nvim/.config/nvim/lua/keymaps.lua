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

-- translate.vim
helper.vmap('t', '<Plug>(Translate)')
