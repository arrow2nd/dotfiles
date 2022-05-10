" 24bitカラー
set termguicolors

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state($HOME . '/.cache/dein')
	let g:dein#cache_directory = $HOME . '/.cache/dein'

	call dein#begin($HOME . '/.cache/dein')
	
	" Let dein manage dein
	" Required:
	call dein#add($HOME . '/.cache/dein/repos/github.com/Shougo/dein.vim')
	
	" Load Plugins
	let s:toml_dir  = $HOME . '/.config/nvim/dein/toml' 
	let s:toml      = s:toml_dir . '/dein.toml'
	let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'
	
	" Cache Tomls
	call dein#load_toml(s:toml,      {'lazy': 0})
	call dein#load_toml(s:lazy_toml, {'lazy': 1})
	
	" Required:
	call dein#end()
	call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" カラースキーム
colorscheme iceberg

" バックアップファイルを作成しない
set nobackup

" スワップファイルを作成しない
set noswapfile

" init.vimを自動で反映
autocmd BufWritePost ~/.cache/init.vim so ~/.config/nvim/init.vim

" デフォルトエンコード
set encoding=utf-8
scriptencoding utf-8

" helpを日本語化
set helplang=ja

" 行番号を表示
set number 

" gitgutter用の列を予め表示
set signcolumn=yes

" 行を折り返さない
set nowrap

" 行末までカーソルを移動可能にする
set virtualedit=onemore

" タブ・インデント
set tabstop=2
set expandtab
set shiftwidth=2
set smartindent

" カーソル形状をターミナルデフォルトから変更しない
set guicursor=

" ヤンクするとクリップボードに保存される
set clipboard+=unnamed

" 検索時に大文字小文字を区別しない
set ignorecase

" 大文字を含む場合はignorecaseを上書き
set smartcase

" インクリメンタルサーチ
set incsearch

" Leaderキー
let mapleader = "\<Space>"

" jキーを2度押しでESC
inoremap <silent> jj <ESC>
inoremap <silent> っj <ESC>

" C-j, C-k でバッファを切替
nnoremap <silent> <C-j> :bprev<cr>
nnoremap <silent> <C-k> :bnext<cr>

" esc2度押しで検索のハイライトを解除
nnoremap <ESC><ESC> :nohlsearch<cr>

" 自動で括弧を閉じる
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

" fern.vim
nnoremap <C-n> :Fern . -drawer -toggle<cr>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" tabで補完候補を選択
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 定義元ジャンプ
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" ドキュメントのホバー表示
nnoremap <silent> K :call <SID>show_documentation()<cr>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" vim-fugitive
nnoremap <leader>ga <cmd>Git add %:p<cr>
nnoremap <leader>gc <cmd>Git commit<cr>
nnoremap <leader>gs <cmd>Git<cr>
nnoremap <leader>gp <cmd>Git push<cr>
nnoremap <leader>gd <cmd>Gdiffsplit<cr>
nnoremap <leader>gl <cmd>Gclog<cr>
