{ lib, osConfig, ... }:

let
  tokenPath = osConfig.services.onepassword-secrets.secretPaths.takumiGuardToken;
in
{
  home.sessionVariables = {
    UV_DEFAULT_INDEX = "https://pypi.flatt.tech/simple/"; # あんまつかわんのでトークンなし
    GOPROXY = "https://golang.flatt.tech";
  };

  # bun はトークン不要なので宣言的に
  home.file.".bunfig.toml".text = ''
    [install]
    registry = "https://npm.flatt.tech/"
  '';

  # トークンを store に入れないよう、opnix が展開したファイルから activation 時に生成する
  home.activation.takumiGuard = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -r "${tokenPath}" ]; then
      TOKEN=$(tr -d '\n' < "${tokenPath}")
    else
      TOKEN=""
    fi

    # 一時ファイルに組み立ててから install で置く（リダイレクトは dry-run でも実行されてしまうため）
    tmp=$(mktemp -d)

    # npm / pnpm / yarn / deno
    echo "registry=https://npm.flatt.tech/" > "$tmp/npmrc"
    if [ -n "$TOKEN" ]; then
      echo "//npm.flatt.tech/:_authToken=$TOKEN" >> "$tmp/npmrc"
    fi
    run install -m 600 "$tmp/npmrc" "$HOME/.npmrc"

    # pip
    if [ -n "$TOKEN" ]; then
      index="https://token:$TOKEN@pypi.flatt.tech/simple/"
    else
      index="https://pypi.flatt.tech/simple/"
    fi
    printf '[global]\nindex-url = %s\n' "$index" > "$tmp/pip.conf"
    run install -D -m 600 "$tmp/pip.conf" "$HOME/.config/pip/pip.conf"

    # Go (.netrc) は他のホストのエントリも入るので、golang.flatt.tech の行だけ差し替える
    if [ -n "$TOKEN" ]; then
      grep -v "golang.flatt.tech" "$HOME/.netrc" > "$tmp/netrc" 2>/dev/null || true
      echo "machine golang.flatt.tech login token password $TOKEN" >> "$tmp/netrc"
      run install -m 600 "$tmp/netrc" "$HOME/.netrc"
    fi

    rm -rf "$tmp"
  '';
}
