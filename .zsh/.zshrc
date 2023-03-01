#
# sheldon
#

eval "$(sheldon source)"

#
# プロンプト
#

MNML_USER_CHAR=""
MNML_INSERT_CHAR=""

#
# パス
#

# Node.js (Volta)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# Golang
export PATH="$HOME/go/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

#
# エイリアス
#

# Git
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gc='git commit'
alias gsw='git switch'

# ghq + fzf
alias q='cd $(ghq list -p | fzf)'

# exa
alias l='exa -la'
alias la='exa -a'
alias lt='exa -T'

# 雑多
alias cls='clear'
alias v="nvim"
alias y='yarn'
alias zmv='noglob zmv -W'
alias rdflint='java -jar rdflint-*.jar'
alias dot='cd ~/dotfiles'
alias tw='nekome tweet'
alias todo='gh todo'

# 天気予報
alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

#
# ローカル設定
#

[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local

#
# 一般設定
#

# ベル無効
setopt no_beep

# 補完候補を方向キーで選択可能にする
zstyle ':completion:*:default' menu select=2

# 入力ミスを訂正
setopt correct

# 日本語ファイル名に対応
setopt print_eight_bit

# ディレクトリ末尾に/を自動付与
setopt auto_param_slash

# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs

# ファイルの種類を示すマークを表示
setopt list_types

# Tab連打で候補を切り替え
setopt auto_menu

# =以降も補完
setopt magic_equal_subst

# 入力途中でも補完
setopt complete_in_word

# ドット無しで隠しファイルをマッチ
setopt globdots

# 大文字・小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Ctrl+Dでログアウトしない
setopt IGNORE_EOF

# zmv
autoload -Uz zmv

#
# 履歴
#

export HISTFILE=${HOME}/.zhistory
export HISTSIZE=1000
export SAVEHIST=1000

# スペースで始まるコマンドを除外
setopt hist_ignore_space

# 重複するコマンドを除外
setopt hist_ignore_dups

# ヒストリに同じコマンドがあるなら古い方を削除
setopt hist_ignore_all_dups

#
# 自動再コンパイル
#

if [ ~/dotfiles/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
