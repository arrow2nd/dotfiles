{ pkgs, inputs, ... }:

let
  rinze = inputs.rinze.packages.${pkgs.stdenv.hostPlatform.system};
  dictionaries = import ../../pkgs/skk-dictionaries.nix { inherit pkgs; };
in
{
  imports = [ inputs.rinze.homeManagerModules.default ];

  # rinzed を常駐させ（Linux は systemd、macOS は launchd）、IME と Neovim で同じ版を共有する。PATH にも入る
  services.rinzed = {
    enable = true;
    package = rinze.rinzed.override {
      dictionaries = rinze.rinzed.dictionaries ++ [
        dictionaries.imas
        dictionaries.emoji
      ];
    };
    # macOS は入力メソッドの rinze.app も入れる。Linux は fcitx5-rinze を modules/linux/fcitx5-skk.nix で入れる
    macos.enable = pkgs.stdenv.hostPlatform.isDarwin;
  };

  # lazy.nvim の dir で読む（.config/nvim/lua/util/rinze.lua）
  xdg.dataFile."nvim/rinze".source = rinze.rinze-nvim;
}
