{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ../../home/common
    ../../home/linux

    ../../home/linux/niri.nix
    ../../home/linux/skk.nix
    ../../home/linux/takumi-guard.nix
    ../../home/linux/ruru-bridge.nix
  ];

  home.sessionVariables.BROWSER = "firefox";

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
      "application/xhtml+xml" = [ "firefox.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    item = "SSHキー (devon)"
    vault = "個人"
  '';

  programs.git.settings.user = {
    email = "44780846+arrow2nd@users.noreply.github.com";
    signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY1VNUT5HxHowIXRVmBRK7LEkB5QmTrE2XMrQFSngG6";
  };

  # Wine が更新するレジストリ全体を固定せず、日本語フォントの代替設定だけを適用する。
  home.activation.wineFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run env WINEPREFIX=${lib.escapeShellArg "${config.home.homeDirectory}/.wine"} \
      LC_ALL=ja_JP.UTF-8 WINEDEBUG=-all \
      ${pkgs.wineWow64Packages.stable}/bin/wine regedit /S ${./wine-fonts.reg}
  '';

  home.packages = with pkgs; [
    firefox
    wineWow64Packages.stable

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
