# nyan-chot

仕事の

## セットアップ

[nix-installer](https://github.com/NixOS/nix-installer) で Nix を入れる

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

初回は darwin-rebuild がまだ無いので↓で

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dotfiles/nix#nyan-chot
```

2回目以降はこう

```sh
sudo darwin-rebuild switch --flake ~/dotfiles/nix#nyan-chot
```

## Git のメアド

仕事用のメアドはリポジトリに置きたくないので nix には入れてない
`~/.config/git/config.local` に書くこと

```ini
[user]
	email = <仕事のメアド>
```
