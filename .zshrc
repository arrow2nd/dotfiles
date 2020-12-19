
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
# プラグイン
#

zinit for \
    light-mode zsh-users/zsh-autosuggestions \
    light-mode zdharma/fast-syntax-highlighting

#
# プロンプト系
#

# テーマ読み込み
zinit light subnixr/minimal

# ランダムな絵文字をプロンプトに設定
() {
    local emoji=('🐑' '🐙' '🐬' '🦐' '🍣' '🦑' '🦀' '🍙' '🐧' '🐌')
    MNML_USER_CHAR=$emoji[($RANDOM % 10 + 1)]
}

#
# パス
#

# anyenv
if [ -d $HOME/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  for D in `command ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

function anyenv_init() {
  eval "$(anyenv init - --no-rehash)"
}
function anyenv_unset() {
  unset -f nodenv
  unset -f goenv
}
function nodenv() {
  anyenv_unset
  anyenv_init
  nodenv "$@"
}
function goenv() {
  anyenv_unset
  anyenv_init
  goenv "$@"
}

# yarn
export PATH="$PATH:`yarn global bin`"

#
# 設定いろいろ
#

# 環境
export LANG=ja_JP.UTF-8
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

