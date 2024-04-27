# 言語
export LANG=ja_JP.UTF-8

# エディタ
export EDITOR=nvim

# Shell
export SHELL=$(which zsh)

# aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
export AQUA_GLOBAL_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/aqua/aqua.yaml"

# 自作スクリプト
export PATH="$HOME/.local/bin:$PATH"

# Neovim
export NEOVIM_HOME=$HOME/.local/nvim
if [ -d "${NEOVIM_HOME}" ]; then
  export PATH="${NEOVIM_HOME}/bin:$PATH"
fi

# mise
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Golang
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# macOS
if [[ $(uname) == "Darwin" ]]; then
  # Homebrew
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit

  # Rancher Desktop
  export PATH="$HOME/.rd/bin:$PATH"
fi

# ローカル設定
[ -f $ZDOTDIR/.zshenv_local ] && . $ZDOTDIR/.zshenv_local
