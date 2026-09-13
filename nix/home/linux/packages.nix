{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    (callPackage ../../pkgs/recordly.nix { })
    oxker
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
