#
# sheldon
#

eval "$(sheldon source)"

#
# Safe-chain Zsh initialization script
#
[[ -f ~/.safe-chain/scripts/init-posix.sh ]] && source ~/.safe-chain/scripts/init-posix.sh 

#
# プロンプト
#

() {
  local emoji=('🐶' '🌴' '🐙' '🐱' '📦' '🍺' '🥗' '🥙' '🍿' '🥝' '🍤' '🍣' '🍛' '🌵')
  MNML_USER_CHAR=$emoji[($RANDOM % $#emoji + 1)]
}

#
# エイリアス (abbr)
#

# Git
abbrev-alias g='git'
abbrev-alias ga='git add'
abbrev-alias gd='GIT_EXTERNAL_DIFF=difft git diff'
abbrev-alias gs='git status'
abbrev-alias gp='git push'
abbrev-alias gpf='git push --force-with-lease --force-if-includes'
abbrev-alias gpu='git pull'
abbrev-alias gb='git branch'
abbrev-alias gc='git commit'
abbrev-alias gf='git fetch'
abbrev-alias gsw='git switch'
abbrev-alias gwt='git wt'
alias git-remote-http-to-ssh='current_url=$(git remote get-url origin 2>/dev/null) && if [[ "$current_url" =~ ^https://github\.com/ ]]; then git remote set-url origin "$(echo "$current_url" | sed "s|https://github.com/|git@github.com:|")"; else echo "Remote is already SSH or not a GitHub HTTPS URL: $current_url"; fi'

# PRをworktreeでチェックアウト
function checkout-pr() {
  local pr_number="$1"

  if [[ -z "$pr_number" ]]; then
    pr_number=$(gh pr list | fzf | awk '{print $1}')
    if [[ -z "$pr_number" ]]; then
      return 1
    fi
  fi

  local branch=$(gh pr view "$pr_number" --json headRefName -q .headRefName)
  if [[ -z "$branch" ]]; then
    echo "PRの情報を取得できませんでした"
    return 1
  fi

  git fetch origin "pull/${pr_number}/head:${branch}" && git wt "$branch"
}

# マージ済み・不要なworktree・ブランチを削除
function cleanup-branches() {
  git fetch --prune

  # worktreeの削除（現在のworktreeを除く）
  git-wt | tail -n +2 | awk '{if ($1 != "*") print $1}' | while read -r branch; do
    git wt -d "$branch" 2>/dev/null
  done

  # worktreeに紐づかないローカルブランチの削除
  local wt_branches=$(git worktree list --porcelain | grep '^branch ' | sed 's|^branch refs/heads/||')
  git branch --format='%(refname:short)' | grep -vxF "$wt_branches" | while read -r branch; do
    git branch -d "$branch" 2>/dev/null
  done
}

# eza
abbrev-alias l='eza -la'
abbrev-alias la='eza -a'
abbrev-alias lt='eza -T'

# brew
abbrev-alias brewu='brew upgrade && brew autoremove && brew cleanup -s'

# Neovim
abbrev-alias v="nvim"
abbrev-alias nvim-rebuild='make distclean && make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/nvim && make install'

# 雑多
abbrev-alias cls='clear'
abbrev-alias zmv='noglob zmv -W'
abbrev-alias dot='cd ~/dotfiles'

# 天気予報
alias wttr='(){ curl -H "Accept-Language: ${LANG%_*}" --compressed "wttr.in/${1:-Tokyo}" }'

# op run
opr () {
  if [[ -f "$PWD/.env" ]]; then
      env_file="$PWD/.env"
  elif [[ -f "$PWD/.env.local" ]]; then
      env_file="$PWD/.env.local"
  else
      echo ".envまたは.env.localがありません"
      return 1
  fi

  who=$(op whoami)
  if [[ $? != 0 ]]; then
      eval $(op signin)
  fi

  op run --env-file="$env_file" -- "$@"
}

#
# ZLE
#

# ghq + fzf でリポジトリへ移動
function ghq-fzf() {
  local dir=$(ghq list -p | fzf)

  if [ -n "$dir" ]; then
    BUFFER="cd ${dir}"
    zle accept-line
  fi

  zle clear-screen
}

zle -N ghq-fzf
bindkey "^f" ghq-fzf

# コマンド履歴を検索
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m)
  zle clear-screen
}

zle -N select-history
bindkey "^h" select-history

# ブランチを切り替える
function select-worktree() {
  local dir=$(git-wt | fzf --header-lines=1 | awk '{if ($1 == "*") print $2; else print $1}')
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
  zle clear-screen
}

zle -N select-worktree
bindkey "^b" select-worktree

# カレント行をnvimで編集
function edit_current_line() {
  local tmpfile=$(mktemp)
  echo "$BUFFER" > $tmpfile
  local cmd="normal! $"
  if [ -z "$BUFFER" ]; then
    cmd="startinsert!"
  fi
  nvim $tmpfile -c "${cmd}" -c "set filetype=zsh"
  BUFFER="$(cat $tmpfile)"
  CURSOR=${#BUFFER}
  rm $tmpfile
  zle reset-prompt
}

zle -N edit_current_line
bindkey '^v' edit_current_line

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
