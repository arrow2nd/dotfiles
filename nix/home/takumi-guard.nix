{ config, lib, pkgs, ... }:
{
  # npm / pnpm / yarn / deno は .npmrc を読む
  home.file.".npmrc".text = ''
    registry=https://npm.flatt.tech/
  '';

  # bun は .bunfig.toml
  home.file.".bunfig.toml".text = ''
    [install]
    registry = "https://npm.flatt.tech/"
  '';

  # pip → XDG準拠で ~/.config/pip/pip.conf
  home.file.".config/pip/pip.conf".text = ''
    [global]
    index-url = https://pypi.flatt.tech/simple/
  '';

  # uv, Go は環境変数経由
  home.sessionVariables = {
    UV_DEFAULT_INDEX = "https://pypi.flatt.tech/simple/";
    GOPROXY = "https://golang.flatt.tech";
  };
}
