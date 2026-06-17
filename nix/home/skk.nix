{ config, pkgs, lib, ... }:

let
  imas-dict-raw = pkgs.fetchurl {
    url = "https://ime.imas-db.jp/dist/skk-jisyo.imas.utf8";
    hash = "sha256-aN9PluChmTs4RjE2ra+qT+hq8lQtEFYiDXdTP4U6h+w=";
  };

  emoji-dict-raw = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/arrow2nd/skk-jisyo-emoji-ja/main/skk-jisyo-emoji-ja.utf8";
    hash = "sha256-uzGxoKqAzJ1ywn1WXS1p96GCVuaeqPy+ds8TUmWQsCY=";
  };

  # そのままだと変換候補にでないのでソート
  imas-dict = pkgs.runCommand "skk-jisyo-imas-sorted" { } ''
    ${pkgs.coreutils}/bin/sort < ${imas-dict-raw} > $out
  '';

  # 区切り行もついでに追加して同じくソート
  emoji-dict = pkgs.runCommand "skk-jisyo-emoji-sorted" { } ''
    {
      echo ";; okuri-ari entries."
      echo ";; okuri-nasi entries."
      ${pkgs.coreutils}/bin/sort < ${emoji-dict-raw}
    } > $out
  '';
in
{
  home.file = {
    ".skk/SKK-JISYO.L".source = "${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L";
    ".skk/skk-jisyo.imas.utf8".source = imas-dict;
    ".skk/skk-jisyo-emoji-ja.utf8".source = emoji-dict;
  };

    # fcitx5-skk は ~/.local/share/fcitx5/skk/dictionary_list を読む
  xdg.dataFile."fcitx5/skk/dictionary_list".text = ''
    type=file,file=${config.home.homeDirectory}/.local/share/fcitx5/skk/user.dict,mode=readwrite
    type=file,file=${config.home.homeDirectory}/.skk/SKK-JISYO.L,mode=readonly
    type=file,file=${config.home.homeDirectory}/.skk/skk-jisyo.imas.utf8,mode=readonly,encoding=UTF-8
    type=file,file=${config.home.homeDirectory}/.skk/skk-jisyo-emoji-ja.utf8,mode=readonly,encoding=UTF-8
  '';
}
