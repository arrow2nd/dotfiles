local h = require("util.helper")

return {
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    version = "v1.*",
    config = function()
      local picker = require("window-picker")

      picker.setup()

      h.nmap("<C-w><C-w>", function()
        local id = picker.pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(id)
      end, { desc = "Pick a window" })
    end
  }
}
