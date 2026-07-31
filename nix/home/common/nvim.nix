{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.tree-sitter

    # efm (mason 管理) の formatCommand が PATH 上の stylua を参照している
    # LSP 本体は mason が入れるので nix では管理しない
    pkgs.stylua
  ];
}
