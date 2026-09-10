---
name: nix-shell
description: Nix（NixOS / nix-darwin / Home Manager）環境で、ツールが未インストールの時や一時的に使いたい時に `nix run` / `nix shell` / `nix develop` を使う手順。`apt`/`brew`/`npm i -g`/`pip install --user` などのグローバルインストール系コマンドを実行する前に必ず読むこと。「ツールが見つからない」「command not found」「インストールしたい」と感じた時のフォールバック先。
---

# Nix 環境でのコマンド実行

このユーザーは NixOS + Home Manager（flakes ベース、`nixpkgs`
stable）を使っている。`/usr/bin` には基本的に何も無く、`apt` / `dnf` / `brew`
も使えない。グローバルインストール（`npm i -g`, `pip install --user`,
`cargo install` をシステム領域へ等）も、Nix 管理外の状態を作るので避ける。

代わりに次のいずれかを使う。

## 判断フロー

1. **コマンドが既に PATH にある** (`command -v <tool>` で確認) → そのまま使う。
2. **1 回だけ実行したい** → `nix run nixpkgs#<pkg> -- <args>`
3. **同じセッションで複数回 / 複数コマンド** →
   `nix shell nixpkgs#<pkg> --command <cmd>` あるいは複数パッケージ列挙
4. **このリポジトリの開発環境に入りたい** → `nix develop`（`flake.nix` に
   `devShells` がある場合）
5. **恒久的に必要** → ユーザーに確認した上で `nix/home/` 配下の Nix 設定（例:
   `nix/home/common/cli-tools.nix`）を編集する

迷ったら 2 か 3 を選ぶ。Nix store にキャッシュされるので 2 回目以降は速い。

## よく使うコマンド

```bash
# 単発実行（例: jq でJSONを整形）
nix run nixpkgs#jq -- '.' < data.json

# 単発でフラグを渡す（-- の後はコマンドへの引数）
nix run nixpkgs#ripgrep -- --json 'pattern' src/

# シェルに入らず 1 コマンドだけ実行（非対話用途で推奨）
nix shell nixpkgs#nodejs_22 --command node --version

# 複数パッケージをまとめて使えるシェル
nix shell nixpkgs#nodejs_22 nixpkgs#pnpm --command sh -c 'pnpm install && pnpm build'

# パッケージ名が分からない時は検索
nix search nixpkgs <keyword>

# 現リポジトリの devShell に入る（flake.nix に定義があれば）
nix develop

# 特定のバージョン / unstable channel を使う
nix run github:NixOS/nixpkgs/nixos-unstable#<pkg>
```

## パッケージ名の注意

`nixpkgs#` の後はそのまま CLI 名と一致しないことが多い。よく外すやつ:

| やりたいこと | パッケージ                                                                         |
| ------------ | ---------------------------------------------------------------------------------- |
| `node`       | `nixpkgs#nodejs_22`（バージョン指定が普通）                                        |
| `python`     | `nixpkgs#python3`                                                                  |
| `pip`        | `nixpkgs#python3Packages.pip` ※基本は `nix shell nixpkgs#python3` 内の venv を使う |
| `rg`         | `nixpkgs#ripgrep`                                                                  |
| `fd`         | `nixpkgs#fd`                                                                       |
| `gh`         | `nixpkgs#gh`                                                                       |
| `psql`       | `nixpkgs#postgresql`                                                               |
| `cc` / `gcc` | `nixpkgs#gcc`                                                                      |

不明なら `nix search nixpkgs <keyword>` で必ず確認してから叩く。当て推量で
`nixpkgs#node` のような不正名を叩くと数十秒待った末に失敗する。

## やってはいけないこと

- `sudo apt install ...` / `brew install ...` — 動かない or システム状態を汚す
- `npm install -g ...` / `pip install --user ...` — Nix 管理外の状態になる
- 黙って `nix-env -i ...` を実行する —
  宣言的構成から外れるので、必要ならユーザーに「`home.nix`
  に追加する？」と確認する
- `nix-shell -p <pkg>`（旧 CLI）を使う — このリポジトリは flakes 前提。新 CLI の
  `nix shell` / `nix run` を使う
- 初回の DL/ビルドが長くなる重量級パッケージ（`texlive.combined.scheme-full`
  等）を確認なしに走らせる

## 速度・キャッシュの感覚

- 初回 `nix run` / `nix shell` は store に無いものを取りに行くので数秒〜分かかる
- 2 回目以降は cache hit で即座に起動する
- `~/.cache/nix/` と `/nix/store` に置かれる。手で消さない

## このリポジトリで恒久追加したい時

`nix/home/common/cli-tools.nix` 等の `home.packages` に追記して、ユーザーに
`home-manager switch --flake .#arrow2nd`(またはそのリポジトリで使われている
switch コマンド) を促す。エージェントが勝手に switch コマンドを実行しない。
