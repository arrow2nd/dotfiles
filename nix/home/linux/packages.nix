{ pkgs, linkDotfile, ... }:
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
    (callPackage ../../pkgs/openpencil.nix { })
  ];

  xdg.configFile = {
    "waybar".source = linkDotfile ".config/waybar";
  };
}
