local wezterm = require 'wezterm'
local act = wezterm.action

local keybinds = {
  -- CTRL-A, CTRL-A で CTRL-A を送る
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendString '\x01' },
  -- コピー&ペースト
  { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  -- タブ
  { key = 't', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'LEADER', action = act.CloseCurrentTab { confirm = true } },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },
  -- ペイン
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  {
    key = 'r',
    mods = 'LEADER',
    action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },
  -- その他
  { key = 'Enter', mods = 'LEADER', action = 'QuickSelect' },
  { key = '/', mods = 'LEADER', action = act.Search('CurrentSelectionOrEmptyString') },
}

local key_tables = {
  resize_pane = {
    { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 1 } },
    { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 1 } },
    { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 1 } },
    { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 1 } },
    { key = 'Enter', action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
  },
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
  leader = { key = 'a', mods = 'CTRL' },
  keys = keybinds,
  key_tables = key_tables,
}
