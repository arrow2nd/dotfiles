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

    # AMD Radeon 860M (Krackan) が Chrome の GPU blocklist で SwiftShader に
    # フォールバックされ WebGL が無効化されるため、blocklist を無視して Vulkan/ANGLE を強制する
    (google-chrome.override {
      commandLineArgs = "--ignore-gpu-blocklist --enable-features=Vulkan";
    })

    (pkgs.callPackage ../../pkgs/anct.nix { })
  ];
}
