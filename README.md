# dotfiles

## 環境

- Manjaro (i3-wm) or macOS (10.15 Catalina ~)
- git, curl 導入済み

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

- macOS の場合は brew 経由で自動でインストールされます

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
./dotfiles/setup.sh
```

### 追記

- node は自動で入らないので `volta install node` とかすること
- GPG 鍵のインポート、git との紐付けは別でやること
- SKK の辞書は `~/.skk/` に置くこと
