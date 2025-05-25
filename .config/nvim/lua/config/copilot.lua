local h = require("util.helper")

vim.g.copilot_no_tab_map = true

h.imap("<C-CR>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
})
