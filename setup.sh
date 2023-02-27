#!/bin/bash

set -eu 

DOT_DIR="$HOME/dotfiles"

MENU="dotfiles (for macOS / Manjaro Sway)

SETUP MENU:
  [a] Execute all
  [i] Install tools
  [l] Link dotfiles
  [s] Setup Git & GitHub CLI
"

install_tools() {
  echo "[ Install tools ]"

  local path="${DOT_DIR}/scripts/install_$(uname).sh"
  if [[ -f "$path" ]]; then
    sh -c "$path"
  else
    echo "$path does not exist."
  fi

  echo ""
}

link_dotfiles() {
  echo "[ Link dotfiles ]"

  if [ -d "$DOT_DIR" ]; then
    for f in $(find . -type f -path '*/.*' -not -path '*.git*' -not -path '*.DS_Store' -not -path '*.luarc.json' | cut -c 3-); do
      mkdir -p "$HOME/$(dirname "$f")"
      if [ -L "$HOME/$f" ]; then
        ln -sfv "$DOT_DIR/$f" "$HOME/$f"
      else
        ln -siv "$DOT_DIR/$f" "$HOME/$f"
      fi
    done
  else
    echo "$DOT_DIR does not exists."
  fi

  echo ""
}

setup_git() {
  sh -c "${DOT_DIR}/scripts/setup_git.sh"
  sh -c "${DOT_DIR}/scripts/setup_gh.sh"
}

if ! type -p git >/dev/null; then
  echo "error: git not found on the system" >&2
  exit 1
fi

echo "$MENU"
read -r result
echo ""

if [[ "$result" == *"a"* ]] || [[ "$result" == *"i"* ]]; then 
  if ! type -p volta >/dev/null; then
    echo "[ Volta (Node.js version manager) ]"
    curl https://get.volta.sh | bash -s -- --skip-setup
  fi

  install_tools
fi

if [[ "$result" == *"a"* ]] || [[ "$result" == *"l"* ]]; then 
  link_dotfiles
fi

if [[ "$result" == *"a"* ]] || [[ "$result" == *"s"* ]]; then 
  setup_git
fi

echo "[ Finished! ]"
