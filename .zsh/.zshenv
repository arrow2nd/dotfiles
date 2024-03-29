# 言語
export LANG=ja_JP.UTF-8

# TUIの表示乱れ防止
export LC_CTYPE=en_US.UTF-8

# エディタ
export EDITOR=nvim

# 自作スクリプト
export PATH="$HOME/.local/bin:$PATH"

# Neovim
export NEOVIM_HOME=$HOME/.local/nvim
if [ -d "${NEOVIM_HOME}" ]; then
  export PATH="${NEOVIM_HOME}/bin:$PATH"
fi

# Node.js (Volta)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

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
