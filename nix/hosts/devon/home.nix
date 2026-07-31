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

  programs.git.settings.user = {
    email = "44780846+arrow2nd@users.noreply.github.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY1VNUT5HxHowIXRVmBRK7LEkB5QmTrE2XMrQFSngG6";
  };

  home.packages = with pkgs; [
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
