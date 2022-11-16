local api = vim.api

local augroup = api.nvim_create_augroup('AutoCommands', {})

-- rdfをxmlとして認識させる
api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = augroup,
  pattern = { '*.rdf' },
  callback = function()
    vim.opt.filetype = 'xml.'

    local full_path = vim.fn.expand('%:p')
    if string.find(full_path, 'imasparql') then
      vim.opt.filetype:append('imasrdf')
    else
      vim.opt.filetype:append('rdf')
    end
  end,
})

-- 常にインサートモードでTerminalを開く
-- ref: https://zenn.dev/ryo_kawamata/articles/improve-neovmi-terminal
api.nvim_create_autocmd({ 'TermOpen' }, {
  group = augroup,
  pattern = { '*' },
  command = 'startinsert',
})
