{ pkgs, ... }:
{
  imports = [ ../nix-settings.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # 実行日時は nix-darwin のデフォルト（毎週日曜 3:15）
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  programs.zsh.enable = true;

  fonts.packages = with pkgs; [
    plemoljp-nf
    udev-gothic-nf
  ];

  # GUI アプリと nix に移さない CLI は Homebrew のまま
  # ホスト固有のものは各ホストの configuration.nix に足す（list なので結合される）
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
    };

    casks = [
      "1password"
      "1password-cli"
      "figma"
      "firefox"
      "google-chrome"
      "shottr"
      "slack"
      "visual-studio-code"
    ];
  };

  system.stateVersion = 7;
}
