{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.tree-sitter
  ];
}
