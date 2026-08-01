{ config, pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
  ];

  home.username = "tanida";
  home.homeDirectory = "/Users/tanida";

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    item = "SSH鍵 (chot)"
    vault = "chot inc."
  '';

  home.packages = with pkgs; [
    act
    awscli2
    awsume
    curl
    # docker CLI 本体は Docker Desktop 同梱のものを使う
    docker-compose
    docker-credential-helpers
    ffmpeg
    ghostscript
    gifsicle
    gnupg
    gnugrep
    imagemagick
    jdk
    jqp
    libfaketime
    pinact
    python311
    qemu
    rustup
    SDL2_image
    supabase-cli
    tree
    uv
    vim
    wget
  ];

  programs.git.settings = {
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe940/Cer2W/RU6jigap5y8RNxbAeIouUR3gNr6dF0R";
    include.path = "${config.xdg.configHome}/git/config.local";

    # 大きめのリポジトリで push が失敗するのを回避
    http.postBuffer = 157286400;
  };
}
