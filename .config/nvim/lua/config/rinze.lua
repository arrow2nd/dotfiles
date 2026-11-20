local rinze = require("rinze")

rinze.setup({ blink = true })

vim.keymap.set("i", "<C-j>", rinze.enable, { silent = true, desc = "rinze を有効にする" })
vim.keymap.set("c", "<C-j>", rinze.enable, { desc = "rinze を有効にする" })
