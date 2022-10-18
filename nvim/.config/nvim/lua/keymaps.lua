local h = require('helper')

-- リーダーキー
vim.g.mapleader = " "

-- ESC
h.imap('jj', '<ESC>')

-- バッファ切り替え
h.nmap('<C-j>', '<CMD>bprev<CR>')
h.nmap('<C-k>', '<CMD>bnext<CR>')

-- タブ
h.nmap('<C-h>', '<CMD>tabprevious<CR>')
h.nmap('<C-l>', '<CMD>tabnext<CR>')
h.nmap('st', '<CMD>tabnew<CR>')
h.nmap('sc', '<CMD>tabclose<CR>')

-- ハイライト解除
h.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>')

-- ヒストリ選択
h.omap('<C-p>', '<Up>')
h.omap('<C-n>', '<Down>')

-- ESCでターミナルを抜ける
h.tmap('<ESC>', '<C-\\><C-n>')

-- telescope.vim
h.nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
h.nmap('<Leader>fb', '<CMD>Telescope buffers<CR>')
h.nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
h.nmap('<Leader>fh', '<CMD>Telescope help_tags<CR>')
h.nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
h.nmap('<C-n>', function()
  return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand("%:p:h") .. '<CR>'
end, { silent = true, expr = true })

-- vim-fugitive
h.nmap('<Leader>gs', '<CMD>Git<CR>')
h.nmap('<Leader>gd', '<CMD>Gdiffsplit<CR>')
h.nmap('<Leader>gc', '<CMD>Git commit<CR>')

-- gitsigns.nvim
h.nmap('<leader>hb', '<CMD>Gitsigns blame_line<CR>')
h.nmap('<leader>hs', '<CMD>Gitsigns stage_hunk<CR>')
h.nmap('<leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>')
h.nmap('<leader>hr', '<CMD>Gitsigns reset_hunk<CR>')
h.nmap('<leader>hp', '<CMD>Gitsigns preview_hunk<CR>')

-- translate.vim
h.vmap('t', '<Plug>(Translate)')
