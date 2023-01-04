local fn = vim.fn

return {
  {
    '4513ECHO/denops-gitter.vim',
    event = 'VeryLazy',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      local token = fn.readfile(fn.expand('~/.config/denops-gitter/.token'))
      vim.g['gitter#token'] = fn.trim(table.concat(token))
      vim.api.nvim_create_user_command('ReadingVimrc', 'new gitter://room/vim-jp/reading-vimrc', {})
    end
  }
}
