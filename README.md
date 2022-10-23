# dotfiles

## 環境

- Arch Linux or macOS (10.15 Catalina ~)
- git, curl 導入済み

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

- macOS の場合は `./install.sh` で brew から自動でインストールされます

## 手順

### 1. 初期設定

```sh
curl https://raw.githubusercontent.com/arrow2nd/dotfiles/main/setup.sh > setup.sh
./setup.sh
```

### 2. `gh` を設定

```
gh auth login
gh extension install kawarimidoll/gh-q
gh extension install arrow2nd/gh-todo
```

### 追記

- node は自動で入らないので `n latest` とかすること
