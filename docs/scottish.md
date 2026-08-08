# scottish

仕事の

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

## Git のメアドと署名鍵

`~/.config/git/config.local` に書く

```ini
[user]
	email = <個人のメアド>
	signingKey = <個人の公開鍵>

[includeIf "gitdir:~/workspace/<社内GitLab>/"]
	path = ~/.config/git/config.work
```

仕事用のgit設定は `~/.config/git/config.work` に

```ini
[user]
	email = <仕事のメアド>
	signingKey = <仕事の公開鍵>
```

`[includeIf]` は `[user]` より後ろに置くこと
先に書くと個人用の設定で上書きされて切り替わらない

## SSH の鍵

`~/.ssh/config.local` に書くこと

```
Host <hoge>
  IdentityFile ~/.ssh/work.pub
  IdentitiesOnly yes

Host github.com
  IdentityFile ~/.ssh/personal.pub
  IdentitiesOnly yes
```
