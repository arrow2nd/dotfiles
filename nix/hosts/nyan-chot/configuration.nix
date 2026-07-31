{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.tanida.home = "/Users/tanida";
  system.primaryUser = "tanida";

  programs.zsh.enable = true;

  # GUI アプリと nix に移さない CLI は Homebrew のまま
  # cleanup = "none": 宣言外のパッケージは消さない（安定してから "zap" を検討）
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
    };

    taps = [
      "arrow2nd/tap"
      "arthur-ficial/tap"
      "mongodb/brew"
      "ngrok/ngrok"
    ];

    brews = [
      # brew services で起動するため brew 管理のまま
      "mysql"
      "mongodb/brew/mongodb-database-tools"

      # nixpkgs に無いカスタム tap のツール
      "arrow2nd/tap/jisyo"
      "arthur-ficial/tap/apfel"
    ];

    casks = [
      "1password"
      "1password-cli"
      "aquaskk"
      "brave-browser"
      "claude"
      "docker-desktop"
      "figma"
      "firealpaca"
      "firefox"
      "floorp"
      "font-plemol-jp-nf"
      "font-udev-gothic-nf"
      "google-chrome"
      "keycastr"
      "microsoft-edge"
      "mongodb-compass"
      "ngrok"
      "notchnook"
      "obs"
      "scroll-reverser"
      "sequel-ace"
      "shottr"
      "slack"
      "spotify"
      "swiftbar"
      "visual-studio-code"
      "vivaldi"
      "zed"
      "zen"
      "zoom"
    ];
  };

  system.stateVersion = 7;
}
