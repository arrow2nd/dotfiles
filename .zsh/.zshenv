# 言語
export LANG=ja_JP.UTF-8

# エディタ
export EDITOR=nvim

# Shell
export SHELL=$(which zsh)

# fzf
export FZF_DEFAULT_OPTS='--height 50% --reverse --border'

# zsh が入れ子で起動されるたびに同じパスが積み重なるのを防ぐ
# -U は配列への代入時にしか効かないので、以降は PATH ではなく path / fpath に足すこと
typeset -U path fpath

# 自作スクリプト
path=("$HOME/.local/bin" $path)

# mise
path=("$HOME/.local/share/mise/shims" $path)

# Deno
path=("$HOME/.deno/bin" $path)

# Add deno completions to search path
# ZDOTDIR は dotfiles リポジトリの symlink なので、生成物はリポジトリ外に置く
ZSH_COMPLETIONS="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions"
fpath=("$ZSH_COMPLETIONS" $fpath)
export FPATH

# Golang
path=("$HOME/go/bin" $path)

# Rust
path=("$HOME/.cargo/bin" $path)

# home-manager の home.sessionVariables
# zsh は home-manager で管理していないので自前で読み込む
HM_SESSION_VARS="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
[ -r "$HM_SESSION_VARS" ] && . "$HM_SESSION_VARS"

# macOS
if [[ $(uname) == "Darwin" ]]; then
  # https://kiririmode.hatenablog.jp/entry/20161106/1478394313
  setopt no_global_rcs

  # Homebrew
  path=("/opt/homebrew/bin" $path)
  fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)

  # PATH自体は nix-darwin 管理の /etc/zshenv が設定してくれる（no_global_rcs より先に読まれる）が、
  # ↑の Homebrew prepend で順序が逆転するため、重複コマンドが nix 優先になるよう先頭に戻す
  if [[ -d /run/current-system ]]; then
    path=("/etc/profiles/per-user/$USER/bin" "/run/current-system/sw/bin" $path)
  fi

  autoload -Uz compinit
  compinit
fi

# ローカル設定
# ZDOTDIR は dotfiles リポジトリの symlink なので、トークン等はリポジトリ外に置く
ZSH_LOCAL_ENV="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshenv_local"
[ -f "$ZSH_LOCAL_ENV" ] && . "$ZSH_LOCAL_ENV"
