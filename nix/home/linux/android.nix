{ pkgs, ... }:
{
  home.packages = with pkgs; [
    android-studio
    android-tools
    scrcpy
  ];
}
