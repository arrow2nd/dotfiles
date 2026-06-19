{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/linux

    ../../home/linux/niri.nix
    ../../home/linux/skk.nix
    ../../home/linux/takumi-guard.nix
  ];

  home.username = "arrow2nd";
  home.homeDirectory = "/home/arrow2nd";

  home.packages = with pkgs; [
    # TODO: これは共通に置いてもいいかも
    deno
    go
    cmake
    gnumake

    google-chrome

    (pkgs.callPackage ../../pkgs/anct.nix { })
  ];
}
