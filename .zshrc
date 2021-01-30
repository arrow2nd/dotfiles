
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

#
# プロンプト
#

# テーマ
zinit light subnixr/minimal

# ランダムな絵文字をプロンプトに設定
() {
    local emoji=('🐑' '🐙' '🐬' '🐧' '🐌' '☕' '🍷' '🍮' '🍤' '🍣' '🍞' '🧀' '🍙' '🌮')
    MNML_USER_CHAR=$emoji[($RANDOM % $#emoji + 1)]
}

#
# プラグイン
#

skip_global_compinit=1

# asdf
. $HOME/.asdf/asdf.sh
fpath=($HOME/.asdf/completions $fpath)

# k
zinit light supercrabtree/k

# https://zdharma.org/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

#
# パス
#

# yarn
export PATH="$PATH:`yarn global bin`"

#
# エイリアス
#

alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gc='git commit'
alias gco='git checkout'

alias dot='cd ~/dotfiles'
alias zshrc='vim ~/dotfiles/.zshrc'

alias la='ls -a'
alias cls='clear'
alias y='yarn'

# 天気予報みたいので…
alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

#
# 設定いろいろ
#

# 環境
export LANG="ja_JP.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# ベル無効
setopt no_beep
# 補完候補を方向キーで選択可能にする
zstyle ':completion:*:default' menu select=2
# 入力ミスを指摘
setopt correct
# 日本語ファイル名に対応
setopt print_eight_bit
# 拡張表記に対応(オプションで^を使う際は\^)
setopt print_eight_bit
# ディレクトリ末尾に/を自動付与
setopt auto_param_slash
# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
# ファイルの種類を示すマークを表示
setopt list_types
# キー連打で候補を切り替え
setopt auto_menu
# =以降も補完する
setopt magic_equal_subst
# 入力途中でも補完する
setopt complete_in_word
# .指定無しで隠しファイルをマッチさせる
setopt globdots

# 履歴
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500

# スペースをで始まるコマンドは履歴に残さない
setopt hist_ignore_space

# 直前と同じコマンドは履歴に残さない
setopt hist_ignore_dups

# 重複するコマンドは履歴に残さない
setopt hist_ignore_all_dups

# 自動再コンパイル
if [ ~/dotfiles/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi

