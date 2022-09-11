vim.api.nvim_set_var('coc_global_extensions', {
  '@yaegassy/coc-tailwindcss3',
  'coc-deno',
  'coc-eslint',
  'coc-go',
  'coc-json',
  'coc-prettier',
  'coc-tsserver',
  'coc-rls',
  'coc-pyright',
  'coc-xml',
})

local silent = { silent = true }

-- ホバー表示
function ShowDocumentation()
  if vim.fn.CocAction('hasProvider', 'hover') then
    vim.fn.CocActionAsync('doHover')
  else
    vim.fn.feedkeys('K', 'in')
  end
end

vim.api.nvim_set_keymap('n', 'K', ':lua ShowDocumentation()<CR>', silent)

-- 補完候補選択
function _G.CheckBackspace()
  local col = vim.fn.col(".") - 1
  local line = vim.fn.getline(".")

  return col == 0 or string.match(string.sub(line, col, col), '%c') == nil
end

vim.api.nvim_set_keymap('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.CheckBackspace() ? "\\<Tab>" : coc#refresh()', {
  silent = true,
  expr = true,
  noremap = true
})

vim.api.nvim_set_keymap('i', '<S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"', {
  silent = true,
  expr = true,
  noremap = true
})

-- 範囲選択
vim.api.nvim_set_keymap('n', '<C-s>', '<Plug>(coc-range-selected)', silent)
vim.api.nvim_set_keymap('x', '<C-s>', '<Plug>(coc-range-selected)', silent)

-- 診断選択
vim.api.nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', silent)
vim.api.nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', silent)

-- 定義元ジャンプ
vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', silent)
vim.api.nvim_set_keymap('n', 'gt', '<Plug>(coc-type-definition)', silent)
vim.api.nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', silent)
vim.api.nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', silent)

-- リネーム
vim.api.nvim_set_keymap('n', '<Leader>rn', '<Plug>(coc-rename)', {})

-- CodeAction適応
vim.api.nvim_set_keymap('n', '<Leader>ca', '<Plug>(coc-codeaction-selected)', silent)
vim.api.nvim_set_keymap('x', '<Leader>ca', '<Plug>(coc-codeaction-selected)', silent)

-- CodeLensAction実行
vim.api.nvim_set_keymap('n', '<Leader>cl', '<Plug>(coc-codelens-action)', silent)

