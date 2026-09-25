# devon

普段の

## セットアップ

UI フォントの x12y12pxMaruMinyaM は Booth 配布で再配布できないので、Booth からダウンロードして先に Nix store に追加しておく。

```sh
nix-store --add-fixed sha256 x12y12pxMaruMinyaM.ttf
```

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nix#devon
```

Home Manager は NixOS モジュールとして組み込んでいるので、上のコマンドで一緒に適用される。
