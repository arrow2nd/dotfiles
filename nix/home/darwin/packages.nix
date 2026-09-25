{ pkgs, ... }:
{
  home.packages = with pkgs; [
    act
    curl
    # docker CLI 本体はホストで入れ方が違う（Docker Desktop 同梱 / nix）ので各ホストで
    docker-compose
    docker-credential-helpers
    ffmpeg
    gnugrep
    gnupg
    imagemagick
    jqp
    rustup
    SDL2_image
    vim
    wget
  ];
}
