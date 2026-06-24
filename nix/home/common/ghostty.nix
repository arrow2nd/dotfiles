{ pkgs, linkDotfile, ... }:
{
  home.packages = [ pkgs.ghostty ];
  xdg.configFile."ghostty".source = linkDotfile ".config/ghostty";
  # TODO: 対して更新しないのでここに設定置いてもいい
}
