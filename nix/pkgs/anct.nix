{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "anct";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "arrow2nd";
    repo = "anct";
    rev = "v${version}";
    hash = "sha256-9VaDe+HbzgeVnTP3yqPsitPGG/EXZTRHJRWI3DbtxG0=";
  };

  vendorHash = "sha256-x0coXS9jYRTgNp33Ja0v/LO3abLoeT20r/SzAOdRlgc=";
  ldflags = [
    "-s"
    "-w"
    "-X github.com/arrow2nd/anct/cmd.version=${version}"
  ];

  meta = with lib; {
    description = "Unofficial CLI Client of Annict";
    homepage = "https://github.com/arrow2nd/anct";
    license = licenses.mit;
    mainProgram = "anct";
  };
}
