{ lib, stdenvNoCC, fetchFromGitHub, imagemagick, gtk3 }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pixelitos-icon-theme";
  version = "20260519";

  src = fetchFromGitHub {
    owner = "ItsZariep";
    repo = "pixelitos-icon-theme";
    rev = finalAttrs.version;
    hash = "sha256-QIaRzJY5R5v0hzjCQwbTiDm2IwDWywlM4ipaVzeEykc=";
  };

  nativeBuildInputs = [ imagemagick gtk3 ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    pushd pixelitos-dark
    bash ./compile-icons.sh
    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r pixelitos-dark $out/share/icons/
    gtk-update-icon-cache -f $out/share/icons/pixelitos-dark || true
    runHook postInstall
  '';

  meta = with lib; {
    description = "16-bit style icon theme";
    homepage = "https://github.com/ItsZariep/pixelitos-icon-theme";
    license = licenses.mit;
    platforms = platforms.all;
  };
})
