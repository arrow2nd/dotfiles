local h = require('util.helper')

-- リーダーキー
vim.g.mapleader = " "

-- 行移動
h.nmap('j', 'gj')
h.nmap('k', 'gk')
h.nmap('gj', 'j')
h.nmap('gk', 'k')

-- タブ
h.nmap('th', '<CMD>tabprevious<CR>', { desc = "Switch to previous tab" })
h.nmap('tl', '<CMD>tabnext<CR>', { desc = "Switch to next tab" })
h.nmap('tn', '<CMD>tabnew<CR>', { desc = "Create new tab" })
h.nmap('tc', '<CMD>tabclose<CR>', { desc = "Close tab" })

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
h.nmap('<Leader>hb', '<CMD>Gitsigns blame_line<CR>', { desc = "Show git blame on the current line" })
h.nmap('<Leader>hp', '<CMD>Gitsigns preview_hunk<CR>', { desc = "Show preview the hunk" })
h.nmap('<Leader>hs', '<CMD>Gitsigns stage_hunk<CR>', { desc = "Stage the hunk" })
h.nmap('<Leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = "Undo the last call of stage hunk" })
h.nmap('<Leader>hr', '<CMD>Gitsigns reset_hunk<CR>', { desc = "Reset the lines of the hunk" })
