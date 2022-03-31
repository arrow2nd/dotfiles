### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#
# プロンプトとか
#

# テーマ
zinit light subnixr/minimal

# ランダムな絵文字をプロンプトに設定
() {
    local emoji=('🐶' '🐱' '🦕' '🐌' '🍹' '🍷' '🍺' '🥙' '🍿' '🥝' '🍤' '🍣' '🍛' '🌵')
    MNML_USER_CHAR=$emoji[($RANDOM % $#emoji + 1)]
}

#
# プラグイン
#

zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    supercrabtree/k

#
# 個別設定
#

[ -f ~/.zshrc_local ] && . ~/.zshrc_local

#
# パス
#

# asdf
. $HOME/.asdf/asdf.sh

# asdf補完設定
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# deno
export PATH="$HOME/.deno/bin:$PATH"

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

# ToDo
alias todo='gh issue list -R arrow2nd/todo'
alias todo-add='gh issue create -a @me -l todo -p my-to-do -R arrow2nd/todo'
alias todo-done='gh issue close -R arrow2nd/todo'
alias todo-view='gh issue view -R arrow2nd/todo'
alias todo-browse='gh browse -R arrow2nd/todo -p'

# 雑多
alias cls='clear'
alias y='yarn'
alias zmv='noglob zmv -W'
alias rdflint='java -jar rdflint-*.jar'
alias tw='twnyan tw'

# 天気予報
alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

#
# 一般設定
#

# 言語
export LANG=ja_JP.UTF-8

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
