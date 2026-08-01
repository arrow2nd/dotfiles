{ config, lib, pkgs, ... }:

{
  programs.niri.settings = {
    environment = {
      # chromium/electron
      NIXOS_OZONE_WL = "1";
    };

    input = {
      keyboard.numlock = true;
      touchpad = {
        tap = true;
        natural-scroll = true;
        accel-speed = 0.2;
      };
      mouse = {
        accel-speed = 0.2;
      };
      trackpoint = {
        accel-speed = 0.2;
      };
    };

    outputs."eDP-1" = {
      mode = {
        width = 1920;
        height = 1200;
      };
      scale = 1.25;
      transform.rotation = 0;
      position = {
        x = 0;
        y = 0;
      };
    };

    cursor = {
      theme = config.home.pointerCursor.name;
      size = config.home.pointerCursor.size;
      hide-when-typing = true;
      hide-after-inactive-ms = 1000;
    };

    layout = {
      gaps = 4;
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 0.5; }
        { proportion = 2.0 / 3.0; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring.enable = false;
      border.enable = false;

      shadow = {
        enable = false;
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#23293488";
      };
    };

    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [
          "swayidle" "-w"
          "timeout" "601" "niri msg action power-off-monitors"
          "timeout" "600" "swaylock -f"
          "before-sleep" "swaylock -f"
        ];
      }
      { command = [ "vicinae" "server" ]; }
      # 壁紙
      { command = [
          "swaybg"
          "-i" "/home/arrow2nd/Pictures/Wallpapers/JpbRcFJRfiABMP3Lj1Cads1F.png"
          "-m" "fill"
        ];
      }
    ];

    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    hotkey-overlay = { };

    animations = { };

    window-rules = [
      # WezTermの初期configure bug回避
      {
        matches = [
          { app-id = "^org\\.wezfurlong\\.wezterm$"; }
        ];
        default-column-width = { };
      }

      # Firefox の PIP をフローティング
      {
        matches = [
          { app-id = "firefox$"; title = "^Picture-in-Picture$"; }
        ];
        open-floating = true;
      }
    ];

    binds = with config.lib.niri.actions; {
      "Mod+E" = {
        hotkey-overlay.title = "Open a Filer";
        action = spawn "nautilus";
      };
      "Mod+B" = {
        hotkey-overlay.title = "Open a Browser";
        action = spawn "google-chrome-stable";
      };
      "Mod+T" = {
        hotkey-overlay.title = "Open a Terminal";
        action = spawn "ghostty";
      };
      "Mod+D" = {
        hotkey-overlay.title = "Run an Application";
        action = spawn "vicinae" "toggle";
      };
      "Super+Alt+L" = {
        hotkey-overlay.title = "Lock the Screen";
        action = spawn "swaylock" "-f";
      };

      # show-hotkey-overlay
      "Mod+Shift+Slash".action = show-hotkey-overlay;

      # Window/Column focus
      "Mod+Left".action  = focus-column-left;
      "Mod+Down".action  = focus-window-down;
      "Mod+Up".action    = focus-window-up;
      "Mod+Right".action = focus-column-right;
      "Mod+H".action     = focus-column-left;
      "Mod+J".action     = focus-window-down;
      "Mod+K".action     = focus-window-up;
      "Mod+L".action     = focus-column-right;

      # Window/Column move
      "Mod+Ctrl+Left".action  = move-column-left;
      "Mod+Ctrl+Down".action  = move-window-down;
      "Mod+Ctrl+Up".action    = move-window-up;
      "Mod+Ctrl+Right".action = move-column-right;
      "Mod+Ctrl+H".action     = move-column-left;
      "Mod+Ctrl+J".action     = move-window-down;
      "Mod+Ctrl+K".action     = move-window-up;
      "Mod+Ctrl+L".action     = move-column-right;

      # Column first/last
      "Mod+Home".action      = focus-column-first;
      "Mod+End".action       = focus-column-last;
      "Mod+Ctrl+Home".action = move-column-to-first;
      "Mod+Ctrl+End".action  = move-column-to-last;

      # Monitor focus
      "Mod+Shift+Left".action  = focus-monitor-left;
      "Mod+Shift+Down".action  = focus-monitor-down;
      "Mod+Shift+Up".action    = focus-monitor-up;
      "Mod+Shift+Right".action = focus-monitor-right;
      "Mod+Shift+H".action     = focus-monitor-left;
      "Mod+Shift+J".action     = focus-monitor-down;
      "Mod+Shift+K".action     = focus-monitor-up;
      "Mod+Shift+L".action     = focus-monitor-right;

      # Column move to monitor
      "Mod+Shift+Ctrl+Left".action  = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+Down".action  = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+Up".action    = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
      "Mod+Shift+Ctrl+H".action     = move-column-to-monitor-left;
      "Mod+Shift+Ctrl+J".action     = move-column-to-monitor-down;
      "Mod+Shift+Ctrl+K".action     = move-column-to-monitor-up;
      "Mod+Shift+Ctrl+L".action     = move-column-to-monitor-right;

      # Workspace focus
      "Mod+Page_Down".action      = focus-workspace-down;
      "Mod+Page_Up".action        = focus-workspace-up;
      "Mod+U".action              = focus-workspace-down;
      "Mod+I".action              = focus-workspace-up;
      "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
      "Mod+Ctrl+Page_Up".action   = move-column-to-workspace-up;
      "Mod+Ctrl+U".action         = move-column-to-workspace-down;
      "Mod+Ctrl+I".action         = move-column-to-workspace-up;

      # Workspace move
      "Mod+Shift+Page_Down".action = move-workspace-down;
      "Mod+Shift+Page_Up".action   = move-workspace-up;
      "Mod+Shift+U".action         = move-workspace-down;
      "Mod+Shift+I".action         = move-workspace-up;

      # Wheel scroll (workspace)
      "Mod+WheelScrollDown" = {
        cooldown-ms = 150;
        action = focus-workspace-down;
      };
      "Mod+WheelScrollUp" = {
        cooldown-ms = 150;
        action = focus-workspace-up;
      };
      "Mod+Ctrl+WheelScrollDown" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-down;
      };
      "Mod+Ctrl+WheelScrollUp" = {
        cooldown-ms = 150;
        action = move-column-to-workspace-up;
      };

      # Wheel scroll (column)
      "Mod+WheelScrollRight".action      = focus-column-right;
      "Mod+WheelScrollLeft".action       = focus-column-left;
      "Mod+Ctrl+WheelScrollRight".action = move-column-right;
      "Mod+Ctrl+WheelScrollLeft".action  = move-column-left;

      # Shift + Wheel (横スクロール代替)
      "Mod+Shift+WheelScrollDown".action      = focus-column-right;
      "Mod+Shift+WheelScrollUp".action        = focus-column-left;
      "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
      "Mod+Ctrl+Shift+WheelScrollUp".action   = move-column-left;

      # Workspace index (Mod+1〜9)
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;

      # Move column to workspace index
      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      # Consume / expel
      "Mod+BracketLeft".action  = consume-or-expel-window-left;
      "Mod+BracketRight".action = consume-or-expel-window-right;
      "Mod+Comma".action        = consume-window-into-column;
      "Mod+Period".action       = expel-window-from-column;

      # Close / Overview
      "Mod+Q" = {
        repeat = false;
        action = close-window;
      };
      "Mod+O" = {
        repeat = false;
        action = toggle-overview;
      };

      # Column width preset
      "Mod+R".action       = switch-preset-column-width;
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+Ctrl+R".action  = reset-window-height;

      # Maximize / Fullscreen
      "Mod+F".action       = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Ctrl+F".action  = expand-column-to-available-width;

      # Center
      "Mod+C".action      = center-column;
      "Mod+Ctrl+C".action = center-visible-columns;

      # Fine width / height adjustments
      "Mod+Minus".action.set-column-width       = "-10%";
      "Mod+Equal".action.set-column-width       = "+10%";
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      # Floating
      "Mod+V".action       = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

      # Tabbed display
      "Mod+W".action = toggle-column-tabbed-display;

      # Volume (PipeWire + wob)
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" ''
          wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.05+ && \
          wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
          awk '{printf "%.0f\n", $2 * 100}' > $XDG_RUNTIME_DIR/wob.sock
        '';
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" ''
          wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05- && \
          wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
          awk '{printf "%.0f\n", $2 * 100}' > $XDG_RUNTIME_DIR/wob.sock
        '';
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" ''
          wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && \
          wpctl get-volume @DEFAULT_AUDIO_SINK@ | \
          awk '{printf "%.0f\n", $2 * 100}' > $XDG_RUNTIME_DIR/wob.sock
        '';
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
      };

      # Media (playerctl)
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action = spawn "playerctl" "play-pause";
      };
      "XF86AudioStop" = {
        allow-when-locked = true;
        action = spawn "playerctl" "stop";
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action = spawn "playerctl" "previous";
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action = spawn "playerctl" "next";
      };

      # Brightness (brightnessctl + wob)
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" ''
          brightnessctl --class=backlight set +10% && \
          brightnessctl -m --class=backlight | \
          cut -d',' -f4 | tr -d '%' > $XDG_RUNTIME_DIR/wob.sock
        '';
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action = spawn "sh" "-c" ''
          brightnessctl --class=backlight set 10%- && \
          brightnessctl -m --class=backlight | \
          cut -d',' -f4 | tr -d '%' > $XDG_RUNTIME_DIR/wob.sock
        '';
      };

      # Screenshot
      "Print".action.screenshot = { };
      "Ctrl+Print".action.screenshot-screen = { };
      "Alt+Print".action.screenshot-window = { };

      # Shortcut inhibit toggle
      "Mod+Escape" = {
        allow-inhibiting = false;
        action = toggle-keyboard-shortcuts-inhibit;
      };

      # Quit / Power
      "Mod+Shift+E".action     = quit;
      "Ctrl+Alt+Delete".action = quit;
      "Mod+Shift+P".action     = power-off-monitors;
    };
  };
}
