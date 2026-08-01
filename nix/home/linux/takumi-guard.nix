{ config, lib, pkgs, ... }:

let
  tokenPath = "/var/lib/opnix/secrets/takumiGuardToken";
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

  home.activation.takumiGuard = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # opnix が展開したトークンファイルを読む
    if [ -r "${tokenPath}" ]; then
      TOKEN=$(cat "${tokenPath}" | tr -d '\n')
    else
      TOKEN=""
    fi

    # npm / pnpm / yarn / deno
    $DRY_RUN_CMD cat > $HOME/.npmrc <<EOF
registry=https://npm.flatt.tech/
EOF
    if [ -n "$TOKEN" ]; then
      $DRY_RUN_CMD echo "//npm.flatt.tech/:_authToken=$TOKEN" >> $HOME/.npmrc
    fi
    $DRY_RUN_CMD chmod 600 $HOME/.npmrc

    # pip
    $DRY_RUN_CMD mkdir -p $HOME/.config/pip
    if [ -n "$TOKEN" ]; then
      $DRY_RUN_CMD cat > $HOME/.config/pip/pip.conf <<EOF
[global]
index-url = https://token:$TOKEN@pypi.flatt.tech/simple/
EOF
    else
      $DRY_RUN_CMD cat > $HOME/.config/pip/pip.conf <<EOF
[global]
index-url = https://pypi.flatt.tech/simple/
EOF
    fi
    $DRY_RUN_CMD chmod 600 $HOME/.config/pip/pip.conf

    # Go (.netrc)
    if [ -n "$TOKEN" ]; then
      $DRY_RUN_CMD touch $HOME/.netrc
      $DRY_RUN_CMD chmod 600 $HOME/.netrc
      $DRY_RUN_CMD grep -v "golang.flatt.tech" $HOME/.netrc > /tmp/netrc-new 2>/dev/null || touch /tmp/netrc-new
      $DRY_RUN_CMD echo "machine golang.flatt.tech login token password $TOKEN" >> /tmp/netrc-new
      $DRY_RUN_CMD mv /tmp/netrc-new $HOME/.netrc
      $DRY_RUN_CMD chmod 600 $HOME/.netrc
    fi
  '';
}
