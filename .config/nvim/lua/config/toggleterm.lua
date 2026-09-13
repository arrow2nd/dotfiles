local h = require("util.helper")

require("toggleterm").setup()

-- keymaps
h.nmap("<Leader><Space>", "<CMD>ToggleTerm<CR>")
h.nmap("<Leader>n", "<CMD>TermNew<CR>")
h.nmap(";t", "<CMD>TermSelect<CR>")

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
end

-- fzfやAI CLIの操作キーを上書きしないよう、ToggleTermだけに適用する。
vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")
