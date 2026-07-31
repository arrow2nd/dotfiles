{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;
    # macOS では pkgs.ghostty が broken 扱いのためバイナリ配布版を使う
    # https://github.com/NixOS/nixpkgs/issues/388984
    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    # mkDefault の項目はプラットフォームで変わる（home/darwin/ghostty.nix で上書き）
    settings = {
      # Font
      window-title-font-family = "PlemolJP Console NF Medium";
      font-family = "PlemolJP Console NF Medium";
      font-size = lib.mkDefault 10;
      font-feature = "-dlig";

      alpha-blending = "native";

      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;
      cursor-color = "#E8E2D6";
      cursor-text = "#232934";

      # Appearance
      mouse-hide-while-typing = true;

      # Colors - Minai Color Scheme
      background = "#232934";
      foreground = "#E8E2D6";
      selection-background = "#DFC2BA";
      selection-foreground = "#232935";
      palette = [
        # Standard colors (0-7)
        "0=#262626"
        "1=#c66471"
        "2=#bbcacb"
        "3=#d4af8d"
        "4=#7ea1b6"
        "5=#9b8ea8"
        "6=#85a3a1"
        "7=#b3b8c2"
        # Bright colors (8-15)
        "8=#818181"
        "9=#D46A74"
        "10=#CED9D9"
        "11=#E0BF9D"
        "12=#82ACC2"
        "13=#ABA1B5"
        "14=#99B0B0"
        "15=#BAC4CF"
      ];

      # Window
      window-decoration = lib.mkDefault "none";
      scrollback-limit = 3500;
      window-theme = lib.mkDefault "ghostty";
      window-padding-x = 8;
      window-padding-y = 8;

      # Copy
      copy-on-select = "clipboard";
      clipboard-trim-trailing-spaces = true;

      # Keybindings
      keybind = [
        "clear"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "global:alt+shift+r=reload_config"
        # tmux 側で shift+enter を拾えるように
        "shift+enter=text:\\x1b\\r"
      ];

      # Application
      shell-integration = "zsh";
      shell-integration-features = "no-cursor";
      quit-after-last-window-closed = false;
    };
  };
}
