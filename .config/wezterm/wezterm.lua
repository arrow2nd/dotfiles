local wezterm = require("wezterm")
local tab_title_list = require("tab_icons")
local act = wezterm.action

local function tab_title(tab_info)
  local title = tab_info.tab_title

  -- title がないなら、アクティブなペインのタイトルを使う
  if not title or #title == 0 then
    local active_title = tab_info.active_pane.title

    -- なんかたまに active_pane.title がないときがある
    if #active_title == 0 then
      title = "zsh"
    else
      title = active_title
    end
  end

  for _, tab in ipairs(tab_title_list) do
    if string.lower(title):match(tab.title) then
      return tab.icon
    end
  end

  return title
end

-- タブのタイトルを設定
wezterm.on("format-tab-title", function(tab)
  local title = tab_title(tab)

  return {
    { Text = " " .. tab.tab_index + 1 .. ". " .. title .. " " },
  }
end)

local function get_battrey_icon(battery)
  if battery.state == "Charging" then
    return " " .. math.floor(battery.state_of_charge * 100) .. "%"
  elseif battery.state == "Unknown" then
    return " ?"
  elseif battery.state_of_charge < 0.1 then
    return " !"
  elseif battery.state_of_charge < 0.2 then
    return " "
  elseif battery.state_of_charge < 0.3 then
    return " "
  elseif battery.state_of_charge < 0.4 then
    return " "
  elseif battery.state_of_charge < 0.5 then
    return " "
  elseif battery.state_of_charge < 0.6 then
    return " "
  elseif battery.state_of_charge < 0.7 then
    return " "
  elseif battery.state_of_charge < 0.8 then
    return " "
  elseif battery.state_of_charge < 0.9 then
    return " "
  else
    return " "
  end
end

wezterm.on("update-right-status", function(window)
  local bat = get_battrey_icon(wezterm.battery_info()[1])
  local time = wezterm.strftime("%H:%M")

  window:set_right_status(wezterm.format({
    { Text = bat },
    { Text = "  " },
    { Text = time },
    { Text = " " },
  }))
end)

local keybinds = {
  -- CTRL-S, CTRL-S で CTRL-S を送る
  -- { key = 's', mods = 'ALT|CTRL', action = act.SendString '\x01' },
  -- コピー&ペースト
  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  -- タブ
  { key = "t", mods = "ALT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "1", mods = "ALT", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT", action = act.ActivateTab(4) },
  { key = "6", mods = "ALT", action = act.ActivateTab(5) },
  { key = "7", mods = "ALT", action = act.ActivateTab(6) },
  { key = "8", mods = "ALT", action = act.ActivateTab(7) },
  { key = "9", mods = "ALT", action = act.ActivateTab(8) },
  -- ペイン
  { key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
  {
    key = "r",
    mods = "ALT",
    action = act.ActivateKeyTable({
      name = "resize_pane",
      one_shot = false,
    }),
  },
  -- その他
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "/", mods = "ALT", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

local key_tables = {
  resize_pane = {
    { key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
    { key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
    { key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
    { key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
    { key = "Enter", action = "PopKeyTable" },
    { key = "Escape", action = "PopKeyTable" },
  },
}

local hyperlink_rules = {
  {
    regex = [[\bhttps?://\S+\b]],
    format = "$0",
  },
  {
    regex = [[\bfile://\S+\b]],
    format = "$0",
  },
}

local font_size = 12

-- 💉 minai
local colors = {
  foreground = "#E8E2D6",
  background = "#232934",

  cursor_fg = "#232934",
  cursor_bg = "#E8E2D6",
  cursor_border = "#E8E2D6",

  selection_fg = "#232935",
  selection_bg = "#DFC2BA",

  split = "#818181",

  tab_bar = {
    background = "#090B0A",

    active_tab = {
      bg_color = "#232934",
      fg_color = "#E8E2D6",
    },

    inactive_tab = {
      bg_color = "#090B0A",
      fg_color = "#B3B8C2",
    },

    inactive_tab_hover = {
      bg_color = "#232934",
      fg_color = "#E8E2D6",
    },

    new_tab = {
      bg_color = "#090B0A",
      fg_color = "#B3B8C2",
    },

    new_tab_hover = {
      bg_color = "#232934",
      fg_color = "#E8E2D6",
    },
  },

  ansi = {
    "#262626",
    "#c66471",
    "#bbcacb",
    "#d4af8d",
    "#7ea1b6",
    "#9b8ea8",
    "#85a3a1",
    "#b3b8c2",
  },
  brights = {
    "#818181",
    "#D46A74",
    "#CED9D9",
    "#E0BF9D",
    "#82ACC2",
    "#ABA1B5",
    "#99B0B0",
    "#BAC4CF",
  },

  compose_cursor = "#d4af8d",

  copy_mode_active_highlight_bg = { Color = "#d4af8d" },
  copy_mode_active_highlight_fg = { Color = "#E8E2D6" },
  copy_mode_inactive_highlight_bg = { Color = "#B06E82" },
  copy_mode_inactive_highlight_fg = { Color = "#E8E2D6" },

  quick_select_label_bg = { Color = "#B06E82" },
  quick_select_label_fg = { Color = "#E8E2D6" },
  quick_select_match_bg = { Color = "#d4af8d" },
  quick_select_match_fg = { Color = "#E8E2D6" },
}

local config = {
  check_for_updates = false,
  front_end = "WebGpu",
  font = wezterm.font("PlemolJP Console NF"),
  font_size = font_size,
  colors = colors,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = false,
  show_new_tab_button_in_tab_bar = true,
  scrollback_lines = 3500,
  disable_default_key_bindings = true,
  keys = keybinds,
  key_tables = key_tables,
  hyperlink_rules = hyperlink_rules,
}

-- macOS
if wezterm.target_triple == "aarch64-apple-darwin" then
  config.window_decorations = "RESIZE"
end

return config
