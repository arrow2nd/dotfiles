#!/bin/bash

set -eu 

DOT_DIR="$HOME/dotfiles"
SCRIPTS_DIR="$DOT_DIR/scripts/$(uname)"

if ! type -p git >/dev/null; then
  echo "error: git not found on the system" >&2
  exit 1
fi

if [[ ! -d "$SCRIPTS_DIR" ]]; then
  echo "error: unsupported environment ($(uname))" >&2
  exit 1
fi

function script_run {
  if [[ ! -f "$1" ]]; then
    echo "$1 does not exist."
    exit 1
  fi

  sh -c "$1"
}

function install_tools {
  echo "[ Install tools ]"

  if ! type -p volta >/dev/null; then
    echo "[ Volta (Node.js version manager) ]"
    curl https://get.volta.sh | bash -s -- --skip-setup
  fi

  script_run "$SCRIPTS_DIR/install.sh"
}

function link_dotfiles {
  echo "[ Link dotfiles ]"

  local links=$(script_run "$SCRIPTS_DIR/find.sh")

  IFS=$'\n'
  for f in $links; do
    mkdir -p "$HOME/$(dirname "$f")"

    if [ -L "$HOME/$f" ]; then
      ln -sfv "$DOT_DIR/$f" "$HOME/$f"
    else
      ln -siv "$DOT_DIR/$f" "$HOME/$f"
    fi
  done
  unset IFS
}

MENU="dotfiles (for macOS / Arch Linux)

SETUP MENU:
  [a] Execute all
  [i] Install tools
  [l] Link dotfiles
  [s] Setup Git & GitHub CLI
"

echo "$MENU"
read -r result
echo ""

if [[ "$result" == *"a"* ]] || [[ "$result" == *"i"* ]]; then 
  install_tools
fi

if [[ "$result" == *"a"* ]] || [[ "$result" == *"l"* ]]; then 
  link_dotfiles
fi

if [[ "$result" == *"a"* ]] || [[ "$result" == *"s"* ]]; then 
  echo "[ Setup Git & GitHub CLI ]"
  script_run "$DOT_DIR/scripts/gh.sh"
fi

echo "[ Finished! ]"
