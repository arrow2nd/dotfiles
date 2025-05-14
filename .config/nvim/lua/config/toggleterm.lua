local h = require("util.helper")
local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup()

-- keymaps
h.nmap("<Leader><Space>", "<CMD>ToggleTerm<CR>")

-- git commit
local git_commit = Terminal:new({
  cmd = "git commit -v",
  hidden = true,
})

h.nmap("<Leader>gc", function()
  git_commit:toggle()
end, { desc = "Git commit" })

-- git push
local git_push = Terminal:new({
  cmd = "git push origin HEAD",
  hidden = true,
})

h.nmap("<Leader>gP", function()
  git_push:toggle()
end, { desc = "Git push" })
