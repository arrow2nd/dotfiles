# dotfiles

## 環境

- Arch Linux or macOS (10.15 Catalina ~)
- Git 導入済み

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

```sh
cd ~
git clone https://github.com/arrow2nd/dotfiles.git
cd dotfiles
./install.sh
```

### gh extension

```
gh auth login
gh extension install kawarimidoll/gh-q
```

- Node.js に関しては自動でインストールされないので、`asdf install nodejs latest` とかすること
