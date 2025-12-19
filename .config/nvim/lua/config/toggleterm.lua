local h = require("util.helper")

require("toggleterm").setup()

-- keymaps
h.nmap("<Leader><Space>", "<CMD>ToggleTerm<CR>")
