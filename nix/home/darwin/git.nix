{ config, ... }:
{
  # macOS では 1Password.app 同梱の op-ssh-sign を使う（nixpkgs の _1password-gui は Linux 専用）
  programs.git.settings."gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  # メアドや署名鍵など、リポジトリに置きたくない設定はここに書く
  programs.git.settings.include.path = "${config.xdg.configHome}/git/config.local";
}
