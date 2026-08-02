{ ... }:
{
  # 1Password agent のソケットパスはプラットフォームで異なるため
  # home/{linux,darwin}/ssh.nix 側で設定する
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "config.local" ];
  };
}
