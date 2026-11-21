# bengal

dotfilesは管理者が `/Users/Shared/dotfiles`
に1つだけクローンし、全ユーザーがそれを参照する。

## セットアップ

[nix-installer](https://github.com/NixOS/nix-installer) で Nix を入れる

```sh
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

管理者のユーザーで clone

```sh
git clone https://github.com/arrow2nd/dotfiles.git /Users/Shared/dotfiles
```

初回は darwin-rebuild がまだ無いので↓

```sh
sudo nix run --extra-experimental-features 'nix-command flakes' nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake /Users/Shared/dotfiles/nix#bengal
```

2回目以降はこう

```sh
sudo darwin-rebuild switch --flake /Users/Shared/dotfiles/nix#bengal
```

home-manager は nix-darwin に組み込んでいるので、各ユーザーで switch
する必要はない。

## 更新

管理者が `git pull` してから switch する。

```sh
git -C /Users/Shared/dotfiles pull
sudo darwin-rebuild switch --flake /Users/Shared/dotfiles/nix#bengal
```

## Git のメアドと署名鍵

リポジトリに置きたくないので nix には入れていない。

各ユーザーの `~/.config/git/config.local` に書くこと

```ini
[user]
	email = <そのユーザーで使うメアド>
	signingKey = <そのユーザーで使う公開鍵>
```
