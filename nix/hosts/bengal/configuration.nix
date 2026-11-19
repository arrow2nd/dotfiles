{ ... }:
{
  # 管理者が /Users/Shared/dotfiles に clone したリポジトリを全ユーザーで参照する
  home-manager.sharedModules = [
    { dotfiles.path = "/Users/Shared/dotfiles"; }
  ];

  homebrew = {
    brews = [
      "coreutils"
    ];

    casks = [
      "aws-vpn-client"
      "obs"
      "tunnelblick"
    ];
  };
}
