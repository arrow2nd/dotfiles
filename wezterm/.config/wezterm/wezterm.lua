local wezterm = require 'wezterm'
local act = wezterm.action

local keybinds = {
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = 'd', mods = 'ALT|CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'ALT|CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 't', mods = 'ALT|CTRL', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'ALT|CTRL', action = act.CloseCurrentTab { confirm = true } },
  { key = "x", mods = "ALT|CTRL", action = act.CloseCurrentPane { confirm = true } },
  { key = 'h', mods = 'ALT|CTRL', action = act.ActivateTabRelative(1) },
  { key = 'l', mods = 'ALT|CTRL', action = act.ActivateTabRelative(-1) },
  { key = "1", mods = "ALT|CTRL", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT|CTRL", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT|CTRL", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT|CTRL", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT|CTRL", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT|CTRL", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT|CTRL", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT|CTRL", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT|CTRL", action = act.ActivateTab(8) },
  { key = "h", mods = "ALT|SHIFT", action = act.ActivatePaneDirection "Left" },
  { key = "l", mods = "ALT|SHIFT", action = act.ActivatePaneDirection "Right" },
  { key = "k", mods = "ALT|SHIFT", action = act.ActivatePaneDirection "Up" },
  { key = "j", mods = "ALT|SHIFT", action = act.ActivatePaneDirection "Down" },
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "/", mods = "ALT", action = act.Search("CurrentSelectionOrEmptyString") },
}

return {
  check_for_updates = false,
  font = wezterm.font 'PlemolJP Console NF',
  font_size = 14,
  color_scheme = 'iceberg-dark',
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  scrollback_lines = 3500,
  disable_default_key_bindings = true,
  keys = keybinds,
}
