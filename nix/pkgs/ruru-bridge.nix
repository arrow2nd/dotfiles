{ lib, buildGoModule, src }:

buildGoModule {
  pname = "ruru-bridge";
  version = "0-unstable-2026-10-20";
  inherit src;
  vendorHash = null;
  ldflags = [ "-s" "-w" ];

  meta = {
    description = "Relay local Orca coding sessions to Ruru over Tailnet";
    homepage = "https://github.com/arrow2nd/ruru-ai";
    license = lib.licenses.mit;
    mainProgram = "ruru-bridge";
    platforms = lib.platforms.linux;
  };
}
