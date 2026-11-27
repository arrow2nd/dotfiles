{ lib, pkgs, ... }:
let
  llamaCppRocm = pkgs.callPackage ../../pkgs/llama-cpp.nix { package = pkgs.llama-cpp-rocm; };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix-settings.nix
    ../../modules/linux/docker.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [ "consoleblank=60" ];

  # Hardware (AMD Ryzen 7 5700X + Radeon RX 7800 XT / RDNA3 gfx1101)
  hardware.enableRedistributableFirmware = true;

  hardware.graphics.enable = true;
  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };

  # zram Swap
  zramSwap.enable = true;

  # 自動スリープ・休止を無効化
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  # Network
  networking.hostName = "mainecoon";
  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    checkReversePath = "loose";
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  # Time & Locale
  time.timeZone = "Asia/Tokyo";
  time.hardwareClockInLocalTime = true;

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
      "video"
      "render"
      "kvm"
    ];
    shell = pkgs.zsh;
  };

  # Shell
  programs.zsh.enable = true;

  # ld-linux (Python / ROCm wheel 等の動的バイナリ実行用)
  programs.nix-ld.enable = true;

  # llama-server
  systemd.tmpfiles.rules = [
    "d /home/arrow2nd/models 0755 arrow2nd users -"
  ];

  systemd.services.llama-server = {
    description = "llama.cpp router server (ROCm)";
    after = [ "network-online.target" "tailscaled.service" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = "arrow2nd";
      Group = "users";
      SupplementaryGroups = [ "video" "render" ];
      ExecStart = lib.escapeShellArgs [
        "${llamaCppRocm}/bin/llama-server"
        "--host" "0.0.0.0"
        "--port" "8080"
        "--models-dir" "/home/arrow2nd/models"
        "--models-max" "1"
        "--sleep-idle-seconds" "600"
        "-ngl" "99"
        "--fit" "on"
        "--flash-attn" "on"
        "--cache-type-k" "q8_0"
        "--cache-type-v" "q8_0"
      ];
      Restart = "on-failure";
      RestartSec = 5;
    };
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

    # AMD GPU / ROCm 確認・監視用
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
    amdgpu_top
    btop-rocm
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # System Version
  system.stateVersion = "26.05";
}
