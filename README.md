# dotfiles

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/673b0ec0-154e-467f-913b-a46063a1209b" />

## 環境

- NixOS or macOS (Apple Silicon)
- Nix (flakes)

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

NixOS (devon) では UI フォントに x12y12pxMaruMinyaM を使う。Booth 配布で再配布できないので、リポジトリには含めていない。
Booth からダウンロードして `~/dotfiles/assets/` (gitignore 済み) に置き、初回の switch の前に Nix store へ追加しておくこと。

```sh
nix-store --add-fixed sha256 ~/dotfiles/assets/x12y12pxMaruMinyaM.ttf
```

追加したファイルはシステムの closure に含めているので GC で消えない。store への追加は端末ごとに 1 回でよい。

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
```

## 追記

- node は自動で入らないので `mise use --global node@lts` とかすること
