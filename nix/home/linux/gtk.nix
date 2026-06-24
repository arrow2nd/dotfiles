{ pkgs, ... }:
let
  pixelitos = pkgs.callPackage ../../pkgs/pixelitos-icon-theme.nix { };
in
{
  gtk = {
    enable = true;
    font = {
      name = "x12y12pxMaruMinyaM";
      size = 10;
    };
    iconTheme = {
      name    = "pixelitos-dark";
      package = pixelitos;
    };
  };
}
