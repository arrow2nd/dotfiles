# bengal

## セットアップ

[nix-installer](https://github.com/NixOS/nix-installer) で Nix を入れる

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

clone

```sh
git clone https://github.com/arrow2nd/dotfiles.git ~/dotfiles
```

初回は darwin-rebuild がまだ無いので↓で

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/dotfiles/nix#bengal
```

2回目以降はこう

```sh
sudo darwin-rebuild switch --flake ~/dotfiles/nix#bengal
```

## Git のメアドと署名鍵

リポジトリに置きたくないので nix には入れてない\
各ユーザーの `~/.config/git/config.local` に書くこと

```ini
[user]
	email = <そのユーザーで使うメアド>
	signingKey = <そのユーザーで使う公開鍵>
```
