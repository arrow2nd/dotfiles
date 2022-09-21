-- Terminalを現在のウィンドウの下部に開く
vim.api.nvim_create_user_command('T', 'split | wincmd j | resize 15 | terminal <args>', { nargs = '*' })
