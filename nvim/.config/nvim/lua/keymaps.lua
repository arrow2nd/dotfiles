local h = require('helper')

-- リーダーキー
vim.g.mapleader = " "

-- スクロール移動
h.nmap('<A-j>', '<C-e>gj', { desc = "Scroll down & Move" })
h.nmap('<A-k>', '<C-y>gk', { desc = "Scroll up & Move" })

-- タブ
h.nmap('<C-h>', '<CMD>tabprevious<CR>', { desc = "Switch to previous tab" })
h.nmap('<C-l>', '<CMD>tabnext<CR>', { desc = "Switch to next tab" })
h.nmap('st', '<CMD>tabnew<CR>', { desc = "Create new tab" })
h.nmap('sc', '<CMD>tabclose<CR>', { desc = "Close tab" })

-- ハイライト解除
h.nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>', { desc = "Unhighlight" })

-- ヒストリ選択
h.omap('<C-p>', '<Up>')
h.omap('<C-n>', '<Down>')

-- ESCでターミナルを抜ける
h.tmap('<ESC>', '<C-\\><C-n>')

-- telescope.vim
h.nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
h.nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
h.nmap('<Leader>fb', '<CMD>Telescope buffers<CR>')
h.nmap('<Leader>fr', '<CMD>Telescope registers<CR>')
h.nmap('<Leader>fk', '<CMD>Telescope keymaps<CR>')
h.nmap('<Leader>fh', '<CMD>Telescope help_tags<CR>')
h.nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
h.nmap('<Leader>bb', function()
  return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand("%:p:h") .. '<CR>'
end, { silent = true, expr = true })

-- vim-fugitive
h.nmap('<Leader>gs', '<CMD>Git<CR>', { desc = "Operate git status" })
h.nmap('<Leader>gd', '<CMD>Gdiffsplit<CR>', { desc = "Show git diff" })
h.nmap('<Leader>gc', '<CMD>Git commit<CR>', { desc = "Operate git commit" })

-- gitsigns.nvim
h.nmap('<leader>hb', '<CMD>Gitsigns blame_line<CR>', { desc = "Show git blame on the current line" })
h.nmap('<leader>hp', '<CMD>Gitsigns preview_hunk<CR>', { desc = "Show preview the hunk" })
h.nmap('<leader>hs', '<CMD>Gitsigns stage_hunk<CR>', { desc = "Stage the hunk" })
h.nmap('<leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = "Undo the last call of stage hunk" })
h.nmap('<leader>hr', '<CMD>Gitsigns reset_hunk<CR>', { desc = "Reset the lines of the hunk" })

-- translate.vim
h.vmap('<leader>tl', '<Plug>(Translate)', { desc = "Translates the selected area" })
