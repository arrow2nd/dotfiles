# dotfiles

## 環境

- Arch Linux or macOS (10.15 Catalina ~)
- git, curl 導入済み

### エディタ

- Neovim
- VSCode / Visual Studio (拡張機能: VSCode Vim / VsVim)

### ターミナル

- kitty (macOS のみ)
- zsh
- sheldon

### 言語 / ランタイム

- Node.js
- Deno
- Golang
- Rust

### フォント

- [PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)
  - macOS の場合は `./install.sh` で brew から自動でインストールされる

## 手順

### 1. 初期設定

#### PC

```sh
curl https://raw.githubusercontent.com/arrow2nd/dotfiles/main/setup.sh > setup.sh
./setup.sh
```

#### Termux

```sh
curl https://raw.githubusercontent.com/arrow2nd/dotfiles/main/setup_termux.sh > setup.sh
./setup.sh
```

### 2. `gh` を設定

```
gh auth login
gh extension install kawarimidoll/gh-q
```

### 追記

- node は自動で入らないので `n latest` とかすること
