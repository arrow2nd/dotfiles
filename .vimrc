
" カラーテーマ読み込み
packadd! onedark.vim

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
    if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
        set termguicolors
    endif
endif

syntax on
colorscheme onedark

let g:lightline = {
    \ 'colorscheme': 'onedark',
    \ }

" 文字コード
set fenc=utf-8
" バックアップを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 自動リロード
set autoread
" 入力中のコマンドを表示
set showcmd

" 行番号表示
set number
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
" ベルを鳴らさない
set belloff=all

" インデント幅
set shiftwidth=4
" タブの挿入幅
set softtabstop=4
" タブの表示幅
set tabstop=4
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

