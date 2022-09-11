local silent = { silent = true }

vim.g.mapleader = " "

vim.api.nvim_set_keymap('i', 'jj', '<ESC>', silent)

-- バッファ切り替え
vim.api.nvim_set_keymap('n', '<C-j>', '<CMD>bprev<CR>', silent)
vim.api.nvim_set_keymap('n', '<C-k>', '<CMD>bnext<CR>', silent)

-- ハイライト解除
vim.api.nvim_set_keymap('n', '<ESC><ESC>', '<CMD>nohlsearch<CR>', silent)

-- ヒストリ選択
vim.api.nvim_set_keymap('c', '<C-p>', '<Up>', {})
vim.api.nvim_set_keymap('c', '<C-n>', '<Down>', {})

-- Fren
vim.api.nvim_set_keymap('n', '<C-n>', '<CMD>Fern . -drawer -toggle<CR>', {})

-- vim-fugitive
vim.api.nvim_set_keymap('n', '<Leader>gs', '<CMD>Git<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gc', '<CMD>Git commit<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gb', '<CMD>Git blame<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gd', '<CMD>Gdiffsplit<CR>', {})
vim.api.nvim_set_keymap('n', '<Leader>gl', '<CMD>Gclog<CR>', {})

