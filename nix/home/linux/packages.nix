{ pkgs, inputs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    inputs.openscreen.packages.${pkgs.stdenv.hostPlatform.system}.default
    # aarch64-darwin ではテストが落ちてビルドできず、macOS では未使用のためここに
    oxker
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
