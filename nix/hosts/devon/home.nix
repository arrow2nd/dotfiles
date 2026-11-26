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

  xdg.mimeApps =
    let
      associate = app: types: lib.genAttrs types (_: [ app ]);
    in
    {
      enable = true;
      defaultApplications = lib.mergeAttrsList [
        (associate "firefox.desktop" [
          "text/html"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "application/pdf"
        ])

        (associate "org.gnome.Nautilus.desktop" [ "inode/directory" ])

        (associate "org.gnome.Loupe.desktop" [
          "image/png"
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/avif"
          "image/bmp"
          "image/tiff"
          "image/svg+xml"
          "image/heic"
          "image/vnd.microsoft.icon"
        ])

        (associate "nvim.desktop" [
          "text/plain"
          "text/markdown"
          "text/x-log"
          "text/csv"
          "text/x-csrc"
          "text/x-chdr"
          "text/x-c++src"
          "text/x-python"
          "text/x-script.python"
          "text/x-shellscript"
          "application/x-shellscript"
          "application/json"
          "application/toml"
          "application/x-yaml"
          "application/xml"
          "application/javascript"
          "text/javascript"
          "application/typescript"
          "text/x-nix"
        ])

        (associate "vlc.desktop" [
          "video/mp4"
          "video/webm"
          "video/x-matroska"
          "video/quicktime"
          "video/x-msvideo"
          "video/mpeg"
          "video/ogg"
          "video/x-flv"
          "video/mp2t"
          "audio/mpeg"
          "audio/mp4"
          "audio/aac"
          "audio/flac"
          "audio/ogg"
          "audio/opus"
          "audio/x-wav"
          "audio/x-m4a"
          "audio/webm"
          "x-content/audio-cdda"
        ])
      ];
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
      ${pkgs.wineWow64Packages.full}/bin/wine regedit /S ${./wine-fonts.reg}
  '';

  # Wine の MIDI 出力先として、ALSA シーケンサーのポートを持つソフトウェアシンセを常駐させる。
  services.fluidsynth = {
    enable = true;
    soundService = "pipewire-pulse";
  };

  home.file.".pi/agent/models.json".text = builtins.toJSON {
    providers = {
      mainecoon = {
        baseUrl = "http://mainecoon:8080/v1";
        api = "openai-completions";
        apiKey = "dummy";
        models = [
          {
            id = "default";
            name = "mainecoon (llama-server)";
            contextWindow = 32768;
            maxTokens = 8192;
          }
        ];
      };
    };
  };

  home.packages = with pkgs; [
    firefox
    discord
    vlc
    # stable は GStreamer 連携なしでビルドされており、DirectShow での音声や動画の再生に失敗するので full を使う。
    wineWow64Packages.full

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.cursor-agent
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi

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
