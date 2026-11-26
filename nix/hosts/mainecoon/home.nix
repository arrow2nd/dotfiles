{ pkgs, ... }:
{
  imports = [
    ../../home/common/lib.nix
    ../../home/common/shell.nix
    ../../home/common/nvim.nix
    ../../home/common/dotfiles-symlinks.nix
    ../../home/common/trash-cleanup.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "arrow2nd";
        email = "44780846+arrow2nd@users.noreply.github.com";
      };
      core.editor = "nvim";
      pull.rebase = false;
    };
  };

  home.packages = with pkgs; [
    fzf
    eza
    fd
    bat
    ripgrep
    jq
    trash-cli
    ghq
    yazi
    fastfetch

    llama-cpp-rocm
    uv
  ];
}
