local h = require("util.helper")
local Terminal = require("toggleterm.terminal").Terminal

require("toggleterm").setup()

-- keymaps
h.nmap("<Leader><Space>", "<CMD>ToggleTerm<CR>")

-- git commit
local git_commit = Terminal:new({
  cmd = "git commit -v",
  close_on_exit = false,
  on_exit = function(t, job, exit_code, name)
    if exit_code == 0 then
      t:close()
    end
  end,
})

h.nmap("<Leader>gc", function()
  git_commit:toggle()
end, { desc = "Git commit" })

-- git push
local git_push = Terminal:new({
  cmd = "git push origin HEAD",
  -- hidden = true,
  close_on_exit = false,
  on_exit = function(t, job, exit_code, name)
    if exit_code == 0 then
      t:close()
    end
  end,
})

h.nmap("<Leader>gP", function()
  git_push:toggle()
end, { desc = "Git push" })
