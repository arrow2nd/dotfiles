local h = require("util.helper")

return {
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    init = function()
      h.nmap("<C-k>", "<CMD>GitMessenger<CR>", { desc = "Show git blame on the current line" })
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  },
}
