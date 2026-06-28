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

    # AMD Radeon 860M (Krackan) は Chrome の GPU blocklist で SwiftShader に
    # フォールバックされ WebGL が無効化されるため blocklist を無視する。
    # ANGLE は GL バックエンドにする。Vulkan バックエンド (--use-angle=vulkan)
    # にすると WebGL は通るが動画レイヤーの DMA-BUF import が壊れて動画が
    # 真っ白になる。GL なら WebGL/WebGPU/動画HWデコードが全て HW で揃う。
    (google-chrome.override {
      commandLineArgs = "--ignore-gpu-blocklist --use-angle=gl";
    })

    (pkgs.callPackage ../../pkgs/anct.nix { })
  ];
}
