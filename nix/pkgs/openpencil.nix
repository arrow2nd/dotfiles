{ appimageTools, fetchurl }:

let
  pname = "openpencil";
  version = "0.13.2";

  src = fetchurl {
    url = "https://github.com/open-pencil/open-pencil/releases/download/v${version}/OpenPencil_${version}_amd64.AppImage";
    hash = "sha256-wgvCxUZ/RXCiJ7TfiJAo24oqWavFu5RLhon2pcZ9BE8=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands =
    let
      contents = appimageTools.extractType2 { inherit pname version src; };
    in
    ''
      install -Dm444 ${contents}/open-pencil.desktop $out/share/applications/open-pencil.desktop
      substituteInPlace $out/share/applications/open-pencil.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=openpencil'
      cp -r ${contents}/usr/share/icons $out/share/icons
    '';
}
