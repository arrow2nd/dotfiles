{ ... }:
{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  # GUI アプリと nix に移さない CLI は Homebrew のまま
  # ホスト固有のものは各ホストの configuration.nix に足す（list なので結合される）
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
    ];

    casks = [
      "1password"
      "1password-cli"
      "aquaskk"
      "figma"
      "firealpaca"
      "firefox"
      "font-plemol-jp-nf"
      "font-udev-gothic-nf"
      "google-chrome"
      "ngrok"
      "shottr"
      "slack"
      "visual-studio-code"
      "zen"
      "zoom"
    ];
  };

  system.stateVersion = 7;
}
