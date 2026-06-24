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
    # フォールバックされ WebGL が無効化されるため、blocklist を無視して ANGLE の
    # バックエンドだけ Vulkan に切り替える。--enable-features=Vulkan はコンポジタ
    # 全体を Vulkan 化して動画フレームが真っ白になるので使わない。
    (google-chrome.override {
      commandLineArgs = "--ignore-gpu-blocklist --use-angle=vulkan";
    })

    (pkgs.callPackage ../../pkgs/anct.nix { })
  ];
}
