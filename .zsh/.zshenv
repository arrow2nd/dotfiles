# 言語
export LANG=ja_JP.UTF-8

# エディタ
export EDITOR=nvim

# Shell
export SHELL=$(which zsh)

# fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border'

# 自作スクリプト
export PATH="$HOME/.local/bin:$PATH"

# mise
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Add deno completions to search path
# ZDOTDIR は dotfiles リポジトリの symlink なので、生成物はリポジトリ外に置く
ZSH_COMPLETIONS="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
if [[ ":$FPATH:" != *":$ZSH_COMPLETIONS:"* ]]; then export FPATH="$ZSH_COMPLETIONS:$FPATH"; fi

# Golang
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Linux
if [[ $(uname) == "Linux" ]]; then
  # 1Password SSH Agent
  export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
fi

# macOS
if [[ $(uname) == "Darwin" ]]; then
  # https://kiririmode.hatenablog.jp/entry/20161106/1478394313
  setopt no_global_rcs

  # Homebrew
  export PATH="/opt/homebrew/bin:$PATH"
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  # PATH自体は nix-darwin 管理の /etc/zshenv が設定してくれる（no_global_rcs より先に読まれる）が、
  # ↑の Homebrew prepend で順序が逆転するため、重複コマンドが nix 優先になるよう先頭に戻す
  if [[ -d /run/current-system ]]; then
    export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$PATH"
  fi

  autoload -Uz compinit
  compinit
fi

# ローカル設定
# ZDOTDIR は dotfiles リポジトリの symlink なので、トークン等はリポジトリ外に置く
ZSH_LOCAL_ENV="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshenv_local"
[ -f "$ZSH_LOCAL_ENV" ] && . "$ZSH_LOCAL_ENV"
