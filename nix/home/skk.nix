{ config, pkgs, lib, ... }:

let
  imas-dict = pkgs.fetchurl {
    url = "https://ime.imas-db.jp/dist/skk-jisyo.imas.utf8";
    hash = lib.fakeHash;
  };

  emoji-dict = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/arrow2nd/skk-jisyo-emoji-ja/main/skk-jisyo-emoji-ja.utf8";
    hash = lib.fakeHash;
  };
in
{
  # SKK 辞書リスト生成
  home.file.".config/fcitx5/skk/dictionary_list".text = ''
    type=file,file=${pkgs.skkDictionaries.l}/share/SKK-JISYO.L,mode=readonly,encoding=EUC-JP
    type=file,file=${imas-dict},mode=readonly,encoding=UTF-8
    type=file,file=${emoji-dict},mode=readonly,encoding=UTF-8
  '';
}
