#!/bin/bash

set -eu

DOT_DIR="$HOME/dotfiles"
SCRIPTS_DIR="$DOT_DIR/scripts/$(uname)"

# gitが無い
if ! type -p git >/dev/null; then
  echo "error: git not found on the system" >&2
  exit 1
fi

# サポート外の環境
if [[ ! -d "$SCRIPTS_DIR" ]]; then
  echo "error: unsupported environment ($(uname))" >&2
  exit 1
fi

# ツールをインストール
function install_tools {
  echo "[ Install tools ]"
  script_run "$SCRIPTS_DIR/install_tools.sh"
}

# .config/ 以下のシンボリックリンクを作成
function link_dotfiles {
  echo "[ Link dotfiles ]"

  local links=$(script_run "$SCRIPTS_DIR/find.sh")
  IFS=$'\n'

  for f in $links; do
    mkdir -p "$HOME/$(dirname "$f")"
    ln -sfv "$DOT_DIR/$f" "$HOME/$f"
  done

  unset IFS
}

echo "dotfiles (for macOS / Ubuntu)"

link_dotfiles
install_tools

echo "✅️ Finished!"
