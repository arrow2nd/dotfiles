local bufnr = vim.api.nvim_get_current_buf()

vim.api.nvim_buf_set_keymap(bufnr, "n", "x", "<Plug>(gin-action-restore)", { noremap = true, silent = true })
vim.api.nvim_buf_set_keymap(bufnr, "n", "X", "<Plug>(gin-action-rm)", { noremap = true, silent = true })
