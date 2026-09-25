{ pkgs, ... }:
{
  nixpkgs.config = {
    android_sdk.accept_license = true;
  };

  home.packages = with pkgs; [
    (android-studio.override { forceWayland = true; })
    android-tools
    scrcpy
  ];
}
