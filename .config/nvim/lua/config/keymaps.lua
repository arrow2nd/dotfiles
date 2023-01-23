local h = require('util.helper')

-- リーダーキー
vim.g.mapleader = ' '

-- 行移動
h.nmap('j', 'gj')
h.nmap('k', 'gk')
h.nmap('gj', 'j')
h.nmap('gk', 'k')

-- タブ
h.nmap('th', '<CMD>tabprevious<CR>', { desc = 'Switch to previous tab' })
h.nmap('tl', '<CMD>tabnext<CR>', { desc = 'Switch to next tab' })
h.nmap('tn', '<CMD>tabnew<CR>', { desc = 'Create new tab' })
h.nmap('tc', '<CMD>tabclose<CR>', { desc = 'Close tab' })

-- ハイライト解除
h.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>', { desc = 'Unhighlight' })

-- ヒストリ選択
h.omap('<C-p>', '<Up>')
h.omap('<C-n>', '<Down>')

-- ESCでターミナルを抜ける
h.tmap('<ESC>', '<C-\\><C-n>')
