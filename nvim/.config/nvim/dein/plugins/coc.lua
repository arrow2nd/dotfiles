local helper = require('helper')

-- 拡張
vim.api.nvim_set_var('coc_global_extensions', {
  '@yaegassy/coc-tailwindcss3',
  'coc-deno',
  'coc-eslint',
  'coc-go',
  'coc-json',
  'coc-lua',
  'coc-prettier',
  'coc-tsserver',
  'coc-rls',
  'coc-pyright',
  'coc-xml',
})

-- ホバー表示
function ShowDocumentation()
  if vim.fn.CocAction('hasProvider', 'hover') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.fn.feedkeys('K', 'in')
  end
end

helper.nmap('K', ':lua ShowDocumentation()<CR>')

-- 補完候補選択
function _G.CheckBackspace()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")
  return col == 0 or string.match(string.sub(line, col, col), '%c') == nil
end

helper.imap('<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\\<Tab>" : coc#refresh()', {
  silent = true,
  expr = true,
  noremap = true
})

helper.imap('<S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"', {
  silent = true,
  expr = true,
  noremap = true
})

-- 範囲選択
helper.nmap('<C-s>', '<Plug>(coc-range-selected)')
helper.xmap('<C-s>', '<Plug>(coc-range-selected)')

-- 診断選択
helper.nmap('[g', '<Plug>(coc-diagnostic-prev)')
helper.nmap(']g', '<Plug>(coc-diagnostic-next)')

-- 定義元ジャンプ
helper.nmap('gd', '<Plug>(coc-definition)')
helper.nmap('gt', '<Plug>(coc-type-definition)')
helper.nmap('gi', '<Plug>(coc-implementation)')
helper.nmap('gr', '<Plug>(coc-references)')

-- リネーム
helper.nmap('<Leader>rn', '<Plug>(coc-rename)')

-- CodeAction適応
helper.nmap('<Leader>ca', '<Plug>(coc-codeaction-selected)')
helper.xmap('<Leader>ca', '<Plug>(coc-codeaction-selected)')

-- CodeLensAction実行
helper.nmap('<Leader>cl', '<Plug>(coc-codelens-action)')

