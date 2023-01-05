local fn = vim.fn

return {
  {
    'vim-denops/denops.vim',
    event = 'VeryLazy',
  },
  {
    '4513ECHO/denops-gitter.vim',
    event = 'VeryLazy',
    init = function()
      vim.api.nvim_create_user_command('ReadingVimrc', 'new gitter://room/vim-jp/reading-vimrc', {})
    end,
    config = function()
      local token = fn.readfile(fn.expand('~/.config/denops-gitter/.token'))
      vim.g['gitter#token'] = fn.trim(table.concat(token))
    end
  }
}
