{ config, ... }:
{
  # store に入れたくない dotfiles を ~/dotfiles からの out-of-store symlink で張るヘルパー
  _module.args.linkDotfile = path:
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/${path}";
}
