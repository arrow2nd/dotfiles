{ config, pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
  ];

  home.username = "tanida";
  home.homeDirectory = "/Users/tanida";

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
    # 署名鍵は公開鍵なので載せてもOK
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe940/Cer2W/RU6jigap5y8RNxbAeIouUR3gNr6dF0R";

    # 会社のメールアドレスは公開リポジトリに載せたくないので、
    # リポジトリ外のローカルファイルから読み込む（無ければ黙って無視される）
    # セットアップ時に ~/.config/git/config.local へ [user] email = ... を書くこと
    include.path = "${config.xdg.configHome}/git/config.local";

    # 大きめのリポジトリで push が失敗するのを回避
    http.postBuffer = 157286400;
  };
}
