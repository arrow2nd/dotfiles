{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.arrow2nd.home = "/Users/arrow2nd";
  system.primaryUser = "arrow2nd";

  programs.zsh.enable = true;

  # Tailscale
  services.tailscale.enable = true;

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
      "ngrok/ngrok"
    ];

    brews = [
      # nixpkgs に無い
      "arrow2nd/tap/jisyo"

      # nixpkgs 版は ls などを prefix 無しで上書きしてしまうので brew 版（g 付き）のまま
      "coreutils"
    ];

    casks = [
      "1password"
      "1password-cli"
      "android-platform-tools"
      "appcleaner"
      "aquaskk"
      "discord"
      "figma"
      "firealpaca"
      "firefox"
      "font-plemol-jp-nf"
      "font-udev-gothic-nf"
      "google-chrome"
      "ngrok"
      "screen-studio"
      "shottr"
      "slack"
      "tunnelblick"
      "visual-studio-code"
      "zen"
      "zoom"
    ];
  };

  system.stateVersion = 7;
}
