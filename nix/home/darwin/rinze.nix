{ pkgs, inputs, ... }:

let
  rinze = inputs.rinze.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ inputs.rinze.homeManagerModules.default ];

  # rinzed を launchd のエージェントで常駐させ、rinze.app と Neovim で同じ版を共有する。PATH にも入る
  services.rinzed = {
    enable = true;
    macos.enable = true;
  };

  # lazy.nvim の dir で読む（.config/nvim/lua/util/rinze.lua）
  xdg.dataFile."nvim/rinze".source = rinze.rinze-nvim;
}
