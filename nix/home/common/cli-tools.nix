{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fzf
    eza
    fd
    bat
    ripgrep
    jq
    difftastic
    trash-cli
    ghq
    git-wt
    btop
    yazi
    fastfetch
    spotify-player

    deno
    go
    cmake
    gnumake
  ];
}
