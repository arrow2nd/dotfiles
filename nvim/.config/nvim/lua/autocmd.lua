vim.api.nvim_create_augroup('lang', {})

-- rdfファイルをxmlファイルとして扱う
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'lang',
  pattern = { '*.rdf' },
  callback = function()
    vim.opt.filetype = 'xml'
  end,
})
