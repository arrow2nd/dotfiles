local h = require("util.helper")

local api = require("overlook.api")

require("overlook").setup({
  -- UI settings for popup windows
  ui = {
    border = "single",              -- Border style: "none", "single", "double", "rounded", etc.
    z_index_base = 30,              -- Base z-index for first popup
    row_offset = 2,                 -- Initial row offset from cursor
    col_offset = 5,                 -- Initial column offset from cursor
    stack_row_offset = 1,           -- Vertical offset for stacked popups
    stack_col_offset = 2,           -- Horizontal offset for stacked popups
    width_decrement = 2,            -- Width reduction for each stacked popup
    height_decrement = 1,           -- Height reduction for each stacked popup
    min_width = 10,                 -- Minimum popup width
    min_height = 3,                 -- Minimum popup height
    size_ratio = 0.65,              -- Default size ratio (0.0 to 1.0)
    keys = {
      close = "q",                  -- Key to close the topmost popup
    },
  },
})

h.nmap("<leader>pd", api.peek_definition, { desc = "Overlook: Peek definition" })
h.nmap("<leader>pc", api.close_all, { desc = "Overlook: Close all popup" })
h.nmap("<leader>pu", api.restore_popup, { desc = "Overlook: Restore popup" })

