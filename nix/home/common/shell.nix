{ pkgs, ... }:
{
  home.packages = with pkgs; [
    sheldon
    mise
    tmux
  ];

  # flakeのdevShellを普段のzshに自動注入するため（.envrcのあるリポジトリで使用）
  # zshへのhookは .zsh/.zshrc 側で行っている
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
