{ config, pkgs, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "arrow2nd";
        email = "44780846+arrow2nd@users.noreply.github.com";
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDY1VNUT5HxHowIXRVmBRK7LEkB5QmTrE2XMrQFSngG6";
      };
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      commit = {
        gpgsign = true;
        template = "${config.xdg.configHome}/git/commit-template";
      };
      core.editor = "nvim";
      pull.rebase = false;
      ghq.root = "${config.home.homeDirectory}/workspace";
    };
  };
}
