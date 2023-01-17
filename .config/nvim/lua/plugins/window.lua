local h = require("util.helper")

return {
  {
    "s1n7ax/nvim-window-picker",
    event = "VeryLazy",
    version = "v1.*",
    config = function()
      local picker = require("window-picker")

      picker.setup({
        selection_chars = "ASDFGHJKL",
        fg_color = "#454545",
        other_win_hl_color = "#89c3eb",
      })

      h.nmap("<C-w><C-w>", function()
        local id = picker.pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(id)
      end, { desc = "Pick a window" })
    end
  }
}
