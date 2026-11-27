-- Sidekick の端末ウィンドウを常に現在のタブへ出す
-- codediff のタブでは diff の横幅を残すため上に開く
local M = {}

local default_layout = nil ---@type string?

---@param tab integer
---@return boolean
local function is_codediff_tab(tab)
  local lifecycle = package.loaded["codediff.ui.lifecycle"]
  return lifecycle ~= nil and lifecycle.get_session(tab) ~= nil
end

---@param terminal table sidekick.cli.Terminal
function M.setup(terminal)
  default_layout = default_layout or terminal.opts.layout

  local is_open = terminal.is_open
  local open_win = terminal.open_win

  function terminal:is_open()
    return is_open(self) and vim.api.nvim_win_get_tabpage(self.win) == vim.api.nvim_get_current_tabpage()
  end

  function terminal:open_win()
    if self.win and vim.api.nvim_win_is_valid(self.win) and not self:is_open() then
      pcall(vim.api.nvim_win_close, self.win, true)
      self.win = nil
    end
    self.opts.layout = is_codediff_tab(vim.api.nvim_get_current_tabpage()) and "top" or default_layout
    return open_win(self)
  end
end

return M
