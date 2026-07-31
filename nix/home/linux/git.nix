{ pkgs, lib, ... }:
{
  # Linux では 1Password の GUI パッケージに op-ssh-sign が同梱されている
  programs.git.settings."gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
}
