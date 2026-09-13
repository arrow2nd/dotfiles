{ lib, appimageTools, fetchurl }:

let
  pname = "recordly";
  version = "1.4.0";
  src = fetchurl {
    url = "https://github.com/webadderallorg/Recordly/releases/download/v${version}/Recordly-linux-x64.AppImage";
    hash = "sha256-N7FsQW7plw4BF6mDmr4LfgJPPwLbdn8aYSJSi4RwSkE=";
  };
  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.pipewire ];

  extraInstallCommands = ''
    install -Dm644 ${extracted}/recordly.desktop $out/share/applications/recordly.desktop
    substituteInPlace $out/share/applications/recordly.desktop \
      --replace-fail "Exec=AppRun" "Exec=recordly"
    mkdir -p $out/share/icons
    cp -r ${extracted}/usr/share/icons/hicolor $out/share/icons/
  '';

  meta = {
    description = "Screen recorder and editor with automatic zoom and cursor effects";
    homepage = "https://github.com/webadderallorg/Recordly";
    platforms = [ "x86_64-linux" ];
    mainProgram = "recordly";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
