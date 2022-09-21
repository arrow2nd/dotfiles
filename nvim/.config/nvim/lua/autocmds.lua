local api = vim.api

-- autocmd
api.nvim_create_augroup('autocmds', {})

-- rdf -> xml
api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'autocmds',
  pattern = { '*.rdf' },
  callback = function()
    vim.opt.filetype = 'xml'
  end,
})

-- 常にインサートモードでTerminalを開く
-- ref: https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal
api.nvim_create_autocmd({ 'TermOpen' }, {
  group = 'autocmds',
  pattern = { '*' },
  command = 'startinsert',
})
