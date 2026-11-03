# devon

普段の

## セットアップ

UI フォントの x12y12pxMaruMinyaM は Booth 配布で再配布できないので、Booth
からダウンロードして `~/dotfiles/assets/` (gitignore 済み) に置き、先に Nix store に追加しておく。

```sh
nix-store --add-fixed sha256 ~/dotfiles/assets/x12y12pxMaruMinyaM.ttf
```

追加したファイルはシステムの closure に含めているので GC で消えない。store への追加は端末ごとに 1 回でよい。

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nix#devon
```
