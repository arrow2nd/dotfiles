local command = vim.api.nvim_create_user_command

-- Terminalを現在のウィンドウの下部に開く
command('T', 'split | wincmd j | resize 15 | terminal <args>', { nargs = '*' })

-- vimrc読書会
command('ReadingVimrc', 'new gitter://room/vim-jp/reading-vimrc', {})
