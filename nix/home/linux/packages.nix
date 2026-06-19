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

  # TODO: ここもめったに更新しないのでsymlinkやめてもいい
  xdg.configFile = {
    "mako".source = link ".config/mako";
    "waybar".source = link ".config/waybar";
    "swaylock".source = link ".config/swaylock";
  };
}
