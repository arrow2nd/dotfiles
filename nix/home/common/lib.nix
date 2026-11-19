{ config, lib, ... }:
{
  options.dotfiles.path = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/dotfiles";
    description = "out-of-store symlink の参照先になる dotfiles リポジトリのパス";
  };

  config = {
    _module.args.linkDotfile = path:
      config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.path}/${path}";

    home.sessionVariables.DOTFILES = config.dotfiles.path;
  };
}
