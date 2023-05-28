local wezterm = require 'wezterm'
local act = wezterm.action

local keybinds = {
  -- CTRL-S, CTRL-S で CTRL-S を送る
  -- { key = 's', mods = 'ALT|CTRL', action = act.SendString '\x01' },
  -- コピー&ペースト
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- タブ
  { key = 't', mods = 'ALT',        action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'c', mods = 'ALT',        action = act.CloseCurrentTab { confirm = true } },
  { key = '1', mods = 'ALT',        action = act.ActivateTab(0) },
  { key = '2', mods = 'ALT',        action = act.ActivateTab(1) },
  { key = '3', mods = 'ALT',        action = act.ActivateTab(2) },
  { key = '4', mods = 'ALT',        action = act.ActivateTab(3) },
  { key = '5', mods = 'ALT',        action = act.ActivateTab(4) },
  { key = '6', mods = 'ALT',        action = act.ActivateTab(5) },
  { key = '7', mods = 'ALT',        action = act.ActivateTab(6) },
  { key = '8', mods = 'ALT',        action = act.ActivateTab(7) },
  { key = '9', mods = 'ALT',        action = act.ActivateTab(8) },
  -- ペイン
  { key = 'v', mods = 'ALT',        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'ALT',        action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'ALT',        action = act.CloseCurrentPane { confirm = true } },
  { key = 'h', mods = 'ALT',        action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'ALT',        action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'ALT',        action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'ALT',        action = act.ActivatePaneDirection 'Down' },
  {
    key = 'r',
    mods = 'ALT',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
  -- その他
  { key = 'Enter', mods = 'ALT',  action = 'QuickSelect' },
  { key = '/',     mods = 'ALT',  action = act.Search('CurrentSelectionOrEmptyString') },
  { key = 'L',     mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
}

local key_tables = {
  resize_pane = {
    { key = 'h',      action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'j',      action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'k',      action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'l',      action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'Enter',  action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

local hyperlink_rules = {
  {
    regex = [[\bhttps?://\S+\b]],
    format = '$0',
  },
  {
    regex = [[\bfile://\S+\b]],
    format = '$0',
  },
}

local font_size = 12

local hostname = wezterm.hostname()
if string.match(hostname, "exotic") then
  -- MacBook Air 2015
  font_size = 10
end

return {
  check_for_updates = false,
  front_end = 'WebGpu',
  font = wezterm.font('PlemolJP Console NF'),
  font_size = font_size,
  color_scheme = 'iceberg-dark',
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  scrollback_lines = 3500,
  disable_default_key_bindings = true,
  keys = keybinds,
  key_tables = key_tables,
  hyperlink_rules = hyperlink_rules,
}
