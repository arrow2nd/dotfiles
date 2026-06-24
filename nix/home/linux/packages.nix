{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
