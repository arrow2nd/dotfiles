{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sheldon
    mise
    tmux
  ];
}
