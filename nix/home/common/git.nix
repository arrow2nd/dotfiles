{ config, lib, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "arrow2nd";
      gpg.format = "ssh";
      commit = {
        gpgsign = true;
        template = "${config.xdg.configHome}/git/commit-template";
      };
      core.editor = "nvim";
      pull.rebase = false;
      ghq.root = "${config.home.homeDirectory}/workspace";
    };
  };

  # 構文認識マージドライバ
  programs.mergiraf = {
    enable = lib.mkDefault true;
    enableGitIntegration = lib.mkDefault true;
  };
}
