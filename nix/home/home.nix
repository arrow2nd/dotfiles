{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

let
  dotfiles = "${config.home.homeDirectory}/dotfiles";

  # mkOutOfStoreSymlinkを楽に書くためのヘルパー
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

  # 1Password SSH agent のソケットパス
  onePassSock = "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  imports = [
    ./niri.nix
  ];

  home.username = "arrow2nd";
  home.homeDirectory = "/home/arrow2nd";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  gtk = {
    enable = true;
    font = {
      name = "BIZ UDPGothic";
      size = 10;
    };
  };

  services.udiskie = {
    enable = true;
  };

  systemd.user.services = {
    # polkit agent
    polkit-gnome-authentication-agent-1 = {
      Unit = {
        Description = "polkit-gnome-authentication-agent-1";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    # wob
    wob = {
      Unit = {
        Description = "Wayland Overlay Bar";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
    };
  };

  systemd.user.sockets.wob = {
    Unit = {
      Description = "Wayland Overlay Bar socket";
    };
    Socket = {
      ListenFIFO = "%t/wob.sock";
      SocketMode = "0600";
      Service = "wob.service";
    };
    Install = {
      WantedBy = [ "sockets.target" ];
    };
  };

  # SSH (1Password SSH agent経由)
  home.sessionVariables.SSH_AUTH_SOCK = onePassSock;
  
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      identityAgent = onePassSock;
    };
  };

  # Git (1Password SSH agentで署名)
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "arrow2nd";
        email = "44780846+arrow2nd@users.noreply.github.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY1VNUT5HxHowIXRVmBRK7LEkB5QmTrE2XMrQFSngG6";
      };
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit.gpgsign = true;
    };
  };

  # dotfiles symlink
  xdg.configFile = {
    "niri/config.kdl".source = link ".config/niri/config.kdl";
    "ghostty".source = link ".config/ghostty";
    "mako".source = link ".config/mako";
    "waybar".source = link ".config/waybar";
    "swaylock".source = link ".config/swaylock";
    "fontconfig".source = link ".config/fontconfig";

    "bat".source = link ".config/bat";
    "mise".source = link ".config/mise";
    "nvim".source = link ".config/nvim";
    "sheldon".source = link ".config/sheldon";
    "tmux".source = link ".config/tmux";
    "typos".source = link ".config/typos";
    "vsnip".source = link ".config/vsnip";
  };

  home.file = {
    ".zshenv".source = link ".zshenv";
    ".zsh".source = link ".zsh";
  };

  # Packages
  home.packages = with pkgs; [
    sheldon
    mise
    tmux

    pkgs-unstable.neovim
    tree-sitter

    fzf
    ghq
    eza
    fd
    bat
    ripgrep
    yazi
    btop
    difftastic
    trash-cli

    deno
    go

    cmake
    gnumake
    less

    gh
  ];
}
