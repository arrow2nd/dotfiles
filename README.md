# dotfiles

<img width="1440" alt="スクリーンショット" src="https://github.com/user-attachments/assets/1287137c-96e6-4d7a-96ca-cedb040e2cc4" />

## 環境

- macOS (Apple Silicon) or Arch Linux
- git 導入済み
- Neovim (HEAD)

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
cd ./dotfiles
./install.sh
```

## 追記

- node は自動で入らないので `mise use --global node@lts` とかすること
- GPG 鍵のインポート、git との紐付けは別でやること
- SKK の辞書は `jisyo d` すると入る
- Git のコミットテンプレートは
  [ここ](https://gist.github.com/arrow2nd/45056915238a1ed84982b4cfff5210d5)
