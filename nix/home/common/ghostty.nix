{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty".source = link ".config/ghostty";
  # TODO: 対して更新しないのでここに設定置いてもいい
}
