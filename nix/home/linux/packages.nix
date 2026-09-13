{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    wl-screenrec
    shotcut
    oxker
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
