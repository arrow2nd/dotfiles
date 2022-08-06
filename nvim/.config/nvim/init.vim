set encoding=utf-8

scriptencoding utf-8

" dein -----------------------------

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

" 外観 -----------------------------

" 24bitカラー
set termguicolors

" カラースキーム
colorscheme iceberg

" 行番号を表示
set number 

" gitgutter用の列を予め表示
set signcolumn=yes

" helpを日本語化
set helplang=ja

" 機能 -----------------------------

" バックアップファイルを作成しない
set nobackup

" スワップファイルを作成しない
set noswapfile

" buffer切り替え時の未保存警告をオフ
set hidden

" 行末までカーソルを移動可能にする
set virtualedit=onemore

" マウス操作を有効化
set mouse=a

" タブ・インデント
set tabstop=2
set expandtab
set shiftwidth=2
set smartindent

" 全ての値を10進数として扱う
set nrformats=

" ヤンクした内容をクリップボードに書込む
set clipboard+=unnamed

" 検索時に大文字小文字を区別しない
set ignorecase

" 大文字を含む場合はignorecaseを上書き
set smartcase

" インクリメンタルサーチ
set incsearch

" ヒストリの上限
set history=255

" autocmd -----------------------------

augroup vimrc
  autocmd!
  " init.vimを自動で反映
  autocmd BufWritePost ~/.cache/init.vim so ~/.config/nvim/init.vim
  " rdfファイルをxmlファイルとして扱う
  autocmd BufNewFile,BufRead *.rdf  set filetype=xml
augroup END

" キーマップ -----------------------------

" Leaderキー
let mapleader = "\<Space>"

" jキーを2度押しでESC
inoremap <silent> jj <ESC>

" C-j, C-k でバッファを切替
nnoremap <silent> <C-j> :bprev<cr>
nnoremap <silent> <C-k> :bnext<cr>

" esc2度押しで検索のハイライトを解除
nnoremap <ESC><ESC> :nohlsearch<cr>

" C-p, C-n でヒストリを選択
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" fern.vim
nnoremap <C-n> :Fern . -drawer -toggle<cr>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fc <cmd>Telescope git_commits<cr>
nnoremap <leader>fs <cmd>Telescope git_status<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" tabで補完候補を選択
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 診断を選択
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

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

" シンボルをリネーム
nmap <leader>rn <Plug>(coc-rename)

" 選択した領域にCodeActionを適応
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" 現在の行にCode Lens Actionを実行
nmap <leader>cl  <Plug>(coc-codelens-action)

" CTRL-Sで範囲を選択
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" vim-fugitive
nnoremap <leader>gc <cmd>Git commit<cr>
nnoremap <leader>gs <cmd>Git<cr>
nnoremap <leader>gp <cmd>Git push<cr>
nnoremap <leader>gd <cmd>Gdiffsplit<cr>
nnoremap <leader>gl <cmd>Gclog<cr>

" コマンド -----------------------------

" Dex (https://github.com/kawarimidoll/deno-dex)
command! -nargs=* -bang Dex silent only! | botright 12 split |
    \ execute 'terminal' (has('nvim') ? '' : '++curwin') 'dex'
    \   (<bang>0 ? '--clear' : '') <q-args> expand('%:p') |
    \ stopinsert | execute 'normal! G' | set bufhidden=wipe |
    \ execute 'autocmd BufEnter <buffer> if winnr("$") == 1 | quit! | endif' |
    \ wincmd k
