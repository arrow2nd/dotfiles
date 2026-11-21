# scottish

## セットアップ

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
