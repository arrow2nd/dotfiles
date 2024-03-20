local h = require("util.helper")

return {
  "rlane/pounce.nvim",
  cmd = { "Pounce", "PounceRepeat" },
  init = function()
    h.nmap("<Leader>j", "<Cmd>Pounce<CR>")
    h.nmap("<Leader>J", "<Cmd>PounceRepeat<CR>")
  end,
}
