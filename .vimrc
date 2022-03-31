syntax on
colorscheme desert

" 文字コード
set encoding=utf-8
" バックアップを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 自動リロード
set autoread
" 入力中のコマンドを表示
set showcmd
" ベルを鳴らさない
set belloff=all

" 行番号表示
set number
" 行末で折り返さない
set nowrap
" 対応する文字を強調
set showmatch
" シンタックスハイライト
syntax on
" コメントの色
hi Comment ctermfg=gray
" ステータスを常に表示
set laststatus=2
" 行末までカーソルを移動可能にする
set virtualedit=onemore

" 自動インデント
set smartindent
" インデント幅
set shiftwidth=2
" タブの挿入幅
set softtabstop=2
" タブの表示幅
set tabstop=2
" タブを半角スペースにする
set expandtab

" 検索にマッチしたものを強調
set hlsearch
" 検索時に大文字小文字を区別しない
set ignorecase
" 大文字を含む場合はignorecaseを上書き
set smartcase
" インクリメンタルサーチ
set incsearch
