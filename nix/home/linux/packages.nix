{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    # aarch64-darwin ではテストが落ちてビルドできず、macOS では未使用のためここに
    oxker
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
