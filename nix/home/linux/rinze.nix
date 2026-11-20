{ config, pkgs, inputs, ... }:

let
  rinze = inputs.rinze.packages.${pkgs.stdenv.hostPlatform.system};

  # skk.nix が ~/.skk に置く辞書を、fcitx5-skk と同じものとして使う
  skkDictionary = name: config.home.file.".skk/${name}".source;
in
{
  home.packages = [
    (rinze.rinzed.override {
      dictionaries = rinze.rinzed.dictionaries ++ [
        (skkDictionary "skk-jisyo.imas.utf8")
        (skkDictionary "skk-jisyo-emoji-ja.utf8")
      ];
    })
  ];

  # lazy.nvim の dir で読む（.config/nvim/lua/util/rinze.lua）
  xdg.dataFile."nvim/rinze".source = rinze.rinze-nvim;
}
