# dotfiles

<img width="1000" alt="macOS" src="https://github.com/arrow2nd/dotfiles/assets/44780846/7e384437-32b5-447d-843c-68dd2e817dd1">

## 環境

- macOS (Apple Silicon) or Arch Linux (Sway / GPD Pocket 2)
- git, curl, make 導入済み
- Neovim (HEAD)

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

- macOS の場合は brew 経由で自動でインストールされます

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
cd ./dotfiles
./setup.sh
```

### 追記

- node は自動で入らないので `volta install node` とかすること
- GPG 鍵のインポート、git との紐付けは別でやること
- SKK の辞書は `jisyo d` すると入る
- nvim は自動でインストールされないので、適当にソースからビルドすること
- Git のコミットテンプレートは
  [ここ](https://gist.github.com/arrow2nd/45056915238a1ed84982b4cfff5210d5)
