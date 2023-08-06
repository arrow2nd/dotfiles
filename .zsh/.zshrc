#
# sheldon
#

eval "$(sheldon source)"

#
# プロンプト
#

() {
  local emoji=('🐴' '🐶' '🦄' '🦀' '🐱' '🍷' '🍺' '🥙' '🍿' '🥝' '🍤' '🍣' '🍛' '🌵')
  MNML_USER_CHAR=$emoji[($RANDOM % $#emoji + 1)]
}

#
# エイリアス (abbr)
#

# Git
abbrev-alias ga='git add'
abbrev-alias gd='git diff'
abbrev-alias gs='git status'
abbrev-alias gp='git push'
abbrev-alias gb='git branch'
abbrev-alias gc='git commit'
abbrev-alias gsw='git switch'

# ブランチ切り替え
abbrev-alias gswf='git switch $(git branch -l | fzf | tr -d "* ")'

# マージ済のブランチをまとめて消す
abbrev-alias g-delete-merged-braches='git branch --merged | grep -v "*" | xargs git branch -d'

# ghq + fzf
abbrev-alias q='cd $(ghq list -p | fzf)'

# exa
abbrev-alias l='exa -la'
abbrev-alias la='exa -a'
abbrev-alias lt='exa -T'

# brew
abbrev-alias brewu='brew upgrade && brew autoremove && brew cleanup -s'

# 雑多
abbrev-alias cls='clear'
abbrev-alias v="nvim"
abbrev-alias zmv='noglob zmv -W'
abbrev-alias dot='cd ~/dotfiles'

# 天気予報
abbrev-alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

#
# キーバインド
#

# コマンド履歴を検索
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m)
  CURSOR=${#BUFFER}
}

zle -N select-history
bindkey "^h" select-history

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
export SAVEHIST=2000

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
