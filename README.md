# dotfiles

<img width="1421" alt="image" src="https://github.com/arrow2nd/dotfiles/assets/44780846/853b93b6-0a58-43e4-ab27-3eb721b61155">

## 環境

- macOS (Apple Silicon) or GitHub Codespaces
- git 導入済み
- Neovim (HEAD)

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

- macOS の場合は brew 経由で自動でインストールされます

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
cd ./dotfiles
./install.sh
```

## 環境変数

- `NVIM_DISABLE_AUTOFORMATTING_PROJECTS`:
  自動フォーマットを無効化するプロジェクトのパス (完全一致 / カンマ区切り)
- `ENABLED_COPILOT`: Copilot を有効化するかどうか

## 追記

- node は自動で入らないので `mise use --global node@lts` とかすること
- GPG 鍵のインポート、git との紐付けは別でやること
- SKK の辞書は `jisyo d` すると入る
- Git のコミットテンプレートは
  [ここ](https://gist.github.com/arrow2nd/45056915238a1ed84982b4cfff5210d5)
