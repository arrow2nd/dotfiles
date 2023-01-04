local fn = vim.fn

return {
  {
    '4513ECHO/denops-gitter.vim',
    cmd = 'ReadingVimrc',
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      local token = fn.readfile(fn.expand('~/.config/denops-gitter/.token'))
      vim.g['gitter#token'] = fn.trim(table.concat(token))
    end
  }
}
