# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix-settings.nix
    ../../modules/linux/fonts.nix
    ../../modules/linux/fcitx5-skk.nix
    ../../modules/linux/docker.nix
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
      "kvm"
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

      sakanaApiKey = {
        reference = "op://nixos-devon/Sakana AI/api_key";
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
    android-studio
    android-tools
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

  # System Version
  system.stateVersion = "26.05";
}

