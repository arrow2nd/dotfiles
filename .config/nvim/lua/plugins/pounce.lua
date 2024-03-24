local h = require("util.helper")

return {
  "rlane/pounce.nvim",
  cmd = { "Pounce", "PounceRepeat" },
  init = function()
    h.nmap("<C-j>", "<Cmd>Pounce<CR>")
    h.nmap("<C-S-j>", "<Cmd>PounceRepeat<CR>")
  end,
}
