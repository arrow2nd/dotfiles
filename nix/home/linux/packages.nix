{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    xwayland-satellite
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
