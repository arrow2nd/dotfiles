---@diagnostic disable: undefined-global
-- ref: https://github.com/skanehira/dotfiles/blob/master/vim/init.lua
for _, mode in pairs({ 'n', 'v', 'i', 'o', 'c', 't', 'x' }) do
  _G[mode .. 'map'] = function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts or { silent = true })
  end
end

-- リーダーキー
vim.g.mapleader = " "

-- ESC
imap('jj', '<ESC>')

-- バッファ切り替え
nmap('<C-j>', '<CMD>bprev<CR>')
nmap('<C-k>', '<CMD>bnext<CR>')

-- ハイライト解除
nmap('<ESC><ESC>', '<CMD>nohlsearch<CR>')

-- ヒストリ選択
omap('<C-p>', '<Up>')
omap('<C-n>', '<Down>')

-- telescope.vim
nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
nmap('<C-n>', function ()
  return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand("%:p:h") .. '<CR>'
end, { silent = true, expr = true })

-- gin.vim
nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>')
nmap('<Leader>gl', '<CMD>GinBuffer ++opener=split log<CR>')
nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>')
nmap('<Leader>gc', '<CMD>Gin commit -v<CR>')
nmap('<Leader>gp', '<CMD>GinPatch ++opener=vsplit<CR>')

-- translate.vim
vmap('t', '<Plug>(Translate)')

-- coc.nvim

-- ホバー表示
function ShowDocumentation()
  if vim.fn.CocAction('hasProvider', 'hover') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.fn.feedkeys('K', 'in')
  end
end

nmap('K', ':lua ShowDocumentation()<CR>')

-- 補完候補選択
function _G.CheckBackspace()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")
  return col == 0 or string.match(string.sub(line, col, col), '%c') == nil
end

imap('<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\\<Tab>" : coc#refresh()', {
  silent = true,
  expr = true,
  noremap = true
})

imap('<S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"', {
  silent = true,
  expr = true,
  noremap = true
})

-- 範囲選択
nmap('<C-s>', '<Plug>(coc-range-selected)')
xmap('<C-s>', '<Plug>(coc-range-selected)')

-- 診断選択
nmap('[g', '<Plug>(coc-diagnostic-prev)')
nmap(']g', '<Plug>(coc-diagnostic-next)')

-- 定義元ジャンプ
nmap('gd', '<Plug>(coc-definition)')
nmap('gt', '<Plug>(coc-type-definition)')
nmap('gi', '<Plug>(coc-implementation)')
nmap('gr', '<Plug>(coc-references)')

-- リネーム
nmap('<Leader>rn', '<Plug>(coc-rename)')

-- CodeAction適応
nmap('<Leader>ca', '<Plug>(coc-codeaction-selected)')
xmap('<Leader>ca', '<Plug>(coc-codeaction-selected)')

-- CodeLensAction実行
nmap('<Leader>cl', '<Plug>(coc-codelens-action)')

