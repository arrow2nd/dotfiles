# 言語
export LANG=ja_JP.UTF-8

# エディタ
export EDITOR=nvim

# Shell
export SHELL=$(which zsh)

# fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border'

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

# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi

# Golang
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# macOS
if [[ $(uname) == "Darwin" ]]; then
  # https://kiririmode.hatenablog.jp/entry/20161106/1478394313
  setopt no_global_rcs

  # Homebrew
  export PATH="/opt/homebrew/bin:$PATH"
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

# ローカル設定
[ -f $ZDOTDIR/.zshenv_local ] && . $ZDOTDIR/.zshenv_local
