local h = require("util.helper")

require("chowcho").setup({
  selector = {
    float = {
      border_style = "single",
      icon_enabled = false,
      color = {
        label = {
          active = "#c8cfff",
          inactive = "#ababab",
        },
        text = {
          active = "#fefefe",
          inactive = "#d0d0d0",
        },
        border = {
          active = "#d162cb",
          inactive = "#fefefe",
        },
      },
      zindex = 1,
    },
  },
})

-- Neovimの<C-w><C-w>をchowcho.nvimで拡張する
-- ref: https://zenn.dev/kawarimidoll/articles/daa39da5838567
local select_window = function()
  local focusable_windows = 0

  for i = 1, vim.fn.winnr("$") do
    local id = vim.fn.win_getid(i)
    local conf = vim.api.nvim_win_get_config(id)

    if conf.focusable then
      focusable_windows = focusable_windows + 1

      if focusable_windows > 2 then
        require("chowcho").run()
        return
      end
    end
  end

  -- 標準の<C-w><C-w>を実行
  vim.api.nvim_command("wincmd w")
end

for _, mode in pairs({ "n", "x" }) do
  local key = mode .. "map"
  local opts = { desc = "Select window" }

  h[key]("<C-w><C-w>", select_window, opts)
  h[key]("<C-w>w", select_window, opts)
end
