{ config, pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
  ];

  home.username = "arrow2nd";
  home.homeDirectory = "/Users/arrow2nd";

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    item = "scottish (GitLab)"
    vault = "jig.jp"

    [[ssh-keys]]
    item = "SSH鍵 (scottish)"
    vault = "個人"
  '';

  home.packages = with pkgs; [
    act
    colima
    curl

    # Docker Desktop は入れていないので CLI は nix 側から
    docker-client
    docker-compose
    docker-credential-helpers
    ffmpeg
    glab
    gnugrep
    gnupg
    httpie
    imagemagick
    jqp
    luarocks
    mergiraf
    mkcert
    pdftk
    potrace
    rustup
    scrcpy
    SDL2_image
    vim
    wget
  ];

  programs.git.settings.include.path = "${config.xdg.configHome}/git/config.local";
}
