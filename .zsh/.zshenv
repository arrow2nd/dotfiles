# 言語
export LANG=ja_JP.UTF-8

# TUIの表示乱れ防止
export LC_CTYPE=en_US.UTF-8

# エディタ
export EDITOR=nvim

# Node.js (Volta)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Golang
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# ローカル設定
[ -f $ZDOTDIR/.zshenv_local ] && . $ZDOTDIR/.zshenv_local
