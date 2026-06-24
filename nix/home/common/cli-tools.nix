{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    eza
    fd
    bat
    ripgrep
    difftastic
    trash-cli
    ghq
    git-wt
    btop
    yazi
    fastfetch
    oxker
  ];
}
