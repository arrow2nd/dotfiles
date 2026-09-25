{ pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/darwin
  ];

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "chot inc."
  '';

  # docker CLI 本体は Docker Desktop 同梱のものを使うので nix では入れない
  home.packages = with pkgs; [
    awscli2
    awsume
    ghostscript
    gifsicle
    jdk
    libfaketime
    pinact
    python311
    qemu
    supabase-cli
    tree
    uv
  ];

  programs.git.settings = {
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFe940/Cer2W/RU6jigap5y8RNxbAeIouUR3gNr6dF0R";

    # 大きめのリポジトリで push が失敗するのを回避
    http.postBuffer = 157286400;
  };
}
