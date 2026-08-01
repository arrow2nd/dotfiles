{ ... }:
{
  # macOS では 1Password.app 同梱の op-ssh-sign を使う（nixpkgs の _1password-gui は Linux 専用）
  programs.git.settings."gpg \"ssh\"".program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
}
