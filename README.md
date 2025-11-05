# dotfiles

<img width="1920" height="1200" alt="Screenshot from 2025-11-05 21-44-48" src="https://github.com/user-attachments/assets/f157a220-31c6-432e-aad2-0c393ac16532" />

## 環境

- Arch Linux or macOS (Apple Silicon)
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
