# dotfiles

<img width="1920" height="1200" alt="image" src="https://github.com/user-attachments/assets/673b0ec0-154e-467f-913b-a46063a1209b" />

## 環境

- NixOS or macOS (Apple Silicon)
- Nix (flakes)

### フォント

[PlemolJP (Nerd Fonts)](https://github.com/yuru7/PlemolJP)

## 手順

```sh
git clone https://github.com/arrow2nd/dotfiles.git $HOME/dotfiles
```

### NixOS

```sh
sudo nixos-rebuild switch --flake ~/dotfiles/nix#devon
home-manager switch --flake ~/dotfiles/nix#arrow2nd
```

### macOS

[nix-installer](https://github.com/NixOS/nix-installer) で Nix を入れる

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

初回は darwin-rebuild がまだ無いので↓で

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dotfiles/nix#scottish
```

2回目以降はこう

```sh
sudo darwin-rebuild switch --flake ~/dotfiles/nix#scottish
```

Git のメアドは macOS 側だと仕事用になることがあるので入れてない
`~/.config/git/config.local` に `[user]` セクションで書くこと

## 追記

- node は自動で入らないので `mise use --global node@lts` とかすること
- SKK の辞書は `jisyo d` すると入る
