{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    bluetuith
    pavucontrol
  ];

  xdg.configFile = {
    "waybar".source = link ".config/waybar";
  };
}
