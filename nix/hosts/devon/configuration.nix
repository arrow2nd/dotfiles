# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, pkgs-unstable, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hardware
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # zram Swap
  zramSwap.enable = true;

  # Configure network connections interactively with nmcli or nmtui.
  networking.hostName = "devon";
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [];
    allowedUDPPorts = [];
    checkReversePath = "loose";
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "ja_JP.UTF-8";
  i18n.extraLocaleSettings = {
    LC_MESSAGES = "en_US.UTF-8";
  };

  console.keyMap = "us";

  # User
  users.users.arrow2nd = {
    isNormalUser = true;
    description = "arrow2nd";
    extraGroups = [
      "wheel"
      "networkmanager"
      "bluetooth"
      "video"
      "audio"
      "input"
      "render"
    ];
    shell = pkgs.zsh;
    initialPassword = "nixos";
  };

  # Shell
  programs.zsh.enable = true;

  # ld-linux
  programs.nix-ld.enable = true;

  # 1Password
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "arrow2nd" ];
  };

  services.onepassword-secrets = {
    enable = true;
    tokenFile = "/etc/opnix-token";
    secrets = {
      # NAS
      smbCreds = {
        reference = "op://nixos-devon/omv_smb2/credentials";
        mode = "0600";
      };

      takumiGuardToken = {
        reference = "op://nixos-devon/takumi_guard/token";
        mode = "0600";
        owner = "arrow2nd";
        group = "users";
      };
    };
  };

  # Wayland / niri
  programs.niri.enable = true;

  # niri-flake が起動する polkit agent を無効化（polkit-gnome つかう）
  systemd.user.services.niri-flake-polkit.enable = false;

  # xdg-desktop-portal
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # polkit + 指紋認証
  security.polkit.enable = true;
  services.fprintd.enable = true;

  security.pam.services = {
    sudo.fprintAuth = true;
    swaylock.fprintAuth = true;
    polkit-1.fprintAuth = true;
    login.fprintAuth = true;
  };

  # SSH
  services.gnome.gcr-ssh-agent.enable = false;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # ly (DM)
  services.displayManager.ly = {
    enable = true;
  };

  # IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      qt6Packages.fcitx5-configtool
    ];
    fcitx5.waylandFrontend = true;
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      # 日本語
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      # コーディング用
      plemoljp-nf

      # BIZ UD
      biz-ud-gothic
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "x12y12pxMaruMinyaM" "BIZ UDPGothic" "Noto Sans CJK JP" ];
        serif = [ "Noto Serif CJK JP" ];
        monospace = [ "PlemolJP Console NF" "Noto Sans Mono CJK JP" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        fcitx5-skk = prev.fcitx5-skk.overrideAttrs (old: {
          cmakeFlags = [
            "-DENABLE_QT=TRUE"
            "-DSKK_PATH=${prev.skkDictionaries.l}/share/skk"
          ];
          buildInputs = (old.buildInputs or []) ++ [
            prev.qt6.qtbase
            prev.qt6Packages.fcitx5-qt
          ];
          nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
            prev.qt6.wrapQtAppsHook
          ];
        });
      })
    ];
  };

  # Packages
  environment.systemPackages = with pkgs; [
    gcc
    git
    vim
    curl
    wget
    less
    unzip
    usbutils
    pciutils
    cifs-utils # SMB クライアント

    # Desktop env
    waybar
    mako
    swaybg
    swayidle
    swaylock
    wl-clipboard
    brightnessctl
    playerctl
    libnotify
    polkit_gnome
    vicinae

    # GUI apps
    grim # スクショ
    slurp # 範囲選択
    nautilus
  ];

  # nautilus
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # NAS マウント
  fileSystems."/mnt/nyas" = {
    device = "//100.113.168.37/nyas";
    fsType = "cifs";
    options = let
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      smb-creds-path = config.services.onepassword-secrets.secretPaths.smbCreds;
    in [
      "${automount_opts},credentials=${smb-creds-path},uid=1000,gid=100,vers=2.0"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # System Version
  system.stateVersion = "26.05";
}

