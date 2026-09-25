{ lib, stdenvNoCC, requireFile }:

stdenvNoCC.mkDerivation {
  name = "x12y12px-maru-minya";

  # Booth 配布でログインが必要なため fetchurl できず、再配布もできないのでリポジトリにも置けない。
  # ファイルは手元から store に追加してもらう
  src = requireFile {
    name = "x12y12pxMaruMinyaM.ttf";
    sha256 = "1q9cbsbf8nmmwv4m7maq0phqd6l193zi7hps4ap6xx6m81ch6dj2";
    message = ''
      x12y12pxMaruMinyaM.ttf が Nix store にありません。
      Booth からダウンロードして、次のコマンドで store に追加してください:

        nix-store --add-fixed sha256 x12y12pxMaruMinyaM.ttf
    '';
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/x12y12pxMaruMinyaM.ttf
    runHook postInstall
  '';

  meta = {
    description = "x12y12pxMaruMinyaM pixel font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
