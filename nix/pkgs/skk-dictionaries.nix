{ pkgs }:

let
  imas-raw = pkgs.fetchurl {
    url = "https://ime.imas-db.jp/dist/skk-jisyo.imas.utf8";
    hash = "sha256-aN9PluChmTs4RjE2ra+qT+hq8lQtEFYiDXdTP4U6h+w=";
  };

  emoji-raw = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/arrow2nd/skk-jisyo-emoji-ja/main/skk-jisyo-emoji-ja.utf8";
    hash = "sha256-uzGxoKqAzJ1ywn1WXS1p96GCVuaeqPy+ds8TUmWQsCY=";
  };
in
{
  # そのままだと変換候補にでないのでソート
  imas = pkgs.runCommand "skk-jisyo-imas-sorted" { } ''
    ${pkgs.coreutils}/bin/sort < ${imas-raw} > $out
  '';

  # 区切り行もついでに追加して同じくソート
  emoji = pkgs.runCommand "skk-jisyo-emoji-sorted" { } ''
    {
      echo ";; okuri-ari entries."
      echo ";; okuri-nasi entries."
      ${pkgs.coreutils}/bin/sort < ${emoji-raw}
    } > $out
  '';
}
