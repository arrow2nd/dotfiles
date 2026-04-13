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

-- zen mode
-- @see https://github.com/folke/zen-mode.nvim?tab=readme-ov-file
wezterm.on("user-var-changed", function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

local keybinds = {
  -- コピー&ペースト
  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  -- タブ
  {
    key = "t",
    mods = "ALT",
    action = wezterm.action_callback(function(window, pane)
      local mux_window = window:mux_window()

      local current_index = 0
      for _, tab_info in ipairs(mux_window:tabs_with_info()) do
        if tab_info.is_active then
          current_index = tab_info.index
          break
        end
      end

      mux_window:spawn_tab({})
      window:perform_action(wezterm.action.MoveTab(current_index + 1), pane)
    end),
  },
  { key = "[", mods = "ALT", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "ALT", action = act.ActivateTabRelative(1) },
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ShowTabNavigator,
  },
  -- ペイン
  { key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "x", mods = "ALT", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
  { key = "9", mods = "ALT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
  { key = "0", mods = "ALT", action = act.PaneSelect },
  -- その他
  { key = "Enter", mods = "ALT", action = "QuickSelect" },
  { key = "/", mods = "ALT", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "L", mods = "CTRL", action = wezterm.action.ShowDebugOverlay },
}

-- タブ切り替え
for i = 1, 5 do
  table.insert(keybinds, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action.ActivateTab(i - 1),
  })
end

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
  font_size = 10,
  colors = colors,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  tab_max_width = 100,
  hide_tab_bar_if_only_one_tab = false,
  show_new_tab_button_in_tab_bar = true,
  scrollback_lines = 3500,
  disable_default_key_bindings = true,
  keys = keybinds,
  hyperlink_rules = hyperlink_rules,
  window_decorations = "NONE",
  window_padding = {
    left = 16,
    right = 16,
    top = 16,
    bottom = 8,
  },
}

-- macOS
if wezterm.target_triple == "aarch64-apple-darwin" then
  config.font_size = 12
  config.window_decorations = "RESIZE"
end

return config
