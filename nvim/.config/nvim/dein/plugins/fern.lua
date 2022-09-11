-- fern-renderer-nerdfont
vim.api.nvim_set_var('fern#renderer', 'nerdfont')

-- glyph-palette
vim.api.nvim_create_augroup('glyph-palette', {})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = 'glyph-palette',
  pattern = { 'fern' },
  callback = function()
    vim.call('glyph_palette#apply')
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = 'glyph-palette',
  pattern = { 'nerdtree', 'startify' },
  callback = function()
    vim.call('glyph_palette#apply')
  end,
})

-- fern
vim.api.nvim_set_var('fern#default_hidden', 1)

vim.api.nvim_set_keymap('n', '<C-n>', '<CMD>Fern . -width=32 -drawer -toggle<CR>', {})
