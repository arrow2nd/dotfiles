{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "lyriflow";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "arrow2nd";
    repo = "lyriflow";
    rev = "v${version}";
    hash = "sha256-KSG+emLDaX2aMQPQ7ML7J0Z8nAQsE6ZU4Xi2S2Vtzts=";
  };

  vendorHash = "sha256-qcXWzjhujX2Tvv+wOSztZLcGnY1qzeLKCnk6AmJhF4Q=";

  # バージョンは main.go の定数で埋め込み済みのため -X 不要
  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Get synchronized lyrics for your music";
    homepage = "https://github.com/arrow2nd/lyriflow";
    mainProgram = "lyriflow";
  };
}
