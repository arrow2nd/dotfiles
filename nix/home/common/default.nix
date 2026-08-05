{ ... }:
{
  imports = [
    ./lib.nix
    ./git.nix
    ./shell.nix
    ./cli-tools.nix
    ./nvim.nix
    ./ssh.nix
    ./gh.nix
    ./ghostty.nix
    ./dotfiles-symlinks.nix
    ./llama-cpp.nix
    ./llm-agents.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
