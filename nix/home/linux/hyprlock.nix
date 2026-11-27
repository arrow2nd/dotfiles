{ lib, pkgs, lockWallpaper, ... }:
let
  font = "Noto Sans CJK JP";
  iconFont = "PlemolJP Console NF";

  shadow = {
    shadow_passes = 2;
    shadow_size = 4;
    shadow_color = "rgba(00000040)";
  };

  text = attrs: {
    color = "rgb(ffffff)";
    font_family = font;
    halign = "center";
    valign = "center";
  } // shadow // attrs;

  # 右上のバッテリー残量と Wi-Fi の接続状態
  status = pkgs.writeShellScript "hyprlock-status" ''
    bat=/sys/class/power_supply/BAT0
    cap=$(cat "$bat/capacity")
    if [ "$(cat "$bat/status")" = Charging ]; then
      icon='\U000f0084'
    else
      # 󰁺 (10%) から 󰂂 (90%) まで連番、100% は 󰁹
      level=$(( cap / 10 ))
      if [ "$level" -ge 10 ]; then
        icon='\U000f0079'
      else
        icon=$(printf '\\U000f%04x' $(( 0x0079 + (level > 0 ? level : 1) )))
      fi
    fi

    if ${lib.getExe' pkgs.networkmanager "nmcli"} -t -f TYPE,STATE dev | grep -q '^wifi:connected$'; then
      wifi='\U000f05a9'
    else
      wifi='\U000f05aa'
    fi

    # Console 版のアイコンは半角幅で右にはみ出して切れるので、末尾に NBSP を足して描画幅を確保
    printf "%s%%  $icon    $wifi " "$cap"
  '';
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
        immediate_render = true;
      };

      auth = {
        "fingerprint:enabled" = true;
        "fingerprint:ready_message" = "指紋またはパスワードで解除";
        "fingerprint:present_message" = "指紋スキャン中...";
      };

      background = [
        {
          path = lockWallpaper;
          color = "rgb(4c484c)";
        }
      ];

      label = [
        # 日付と時計
        (text {
          text = ''cmd[update:60000] date '+%-m月%-d日 %A' '';
          font_size = 22;
          position = "0, 39%";
        })
        (text {
          text = ''<span font_weight="bold">$TIME</span>'';
          font_size = 96;
          position = "0, 30%";
        })

        # アバターの絵文字
        (text {
          text = "🐱";
          font_family = "Noto Color Emoji";
          font_size = 26;
          position = "0, -33.1%";
          shadow_passes = 0;
        })

        (text {
          text = ''<span font_weight="bold">$USER</span>'';
          font_size = 15;
          position = "0, -39%";
        })

        # 指紋の待機状態と失敗理由
        (text {
          text = "$FPRINTPROMPT";
          color = "rgba(ffffffdd)";
          font_size = 12;
          position = "0, -43%";
        })

        (text {
          text = "cmd[update:5000] ${status}";
          font_family = iconFont;
          font_size = 13;
          position = "-24, -14";
          halign = "right";
          valign = "top";
        })
      ];

      # アバターの円
      shape = [
        {
          size = "72, 72";
          color = "rgba(ffffff55)";
          rounding = -1;
          border_size = 0;
          position = "0, -33%";
          halign = "center";
          valign = "center";
        }
      ];

      # 入力欄
      input-field = [
        {
          size = "236, 36";
          position = "0, -43%";
          halign = "center";
          valign = "center";
          zindex = 1;
          rounding = -1;
          outline_thickness = 0;
          inner_color = "rgba(2a282ce6)";
          font_color = "rgb(ffffff)";
          font_family = font;
          dots_size = 0.2;
          dots_spacing = 0.3;
          fade_on_empty = true;
          placeholder_text = "";
          fail_text = "$FAIL";
          check_color = "rgba(4a474ce6)";
          fail_color = "rgba(b36b6bf0)";
          capslock_color = "rgba(b39b5bf0)";
        }
      ];
    };
  };
}
