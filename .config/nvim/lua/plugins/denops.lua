local h = require('util.helper')

return {
  {
    'vim-denops/denops.vim',
    event = 'VeryLazy',
  },
  {
    'vim-skk/skkeleton',
    event = 'VeryLazy',
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      h.imap('<C-j>', '<Plug>(skkeleton-enable)')
      h.cmap('<C-j>', '<Plug>(skkeleton-enable)')

      vim.api.nvim_create_autocmd('User', {
        pattern = 'skkeleton-initialize-pre',
        callback = function()
          vim.fn['skkeleton#config']({
            eggLikeNewline = true,
            skkServerPort = 1178,
            useSkkServer = true,
          })
        end
      })
    end
  },
  {
    'skanehira/denops-translate.vim',
    dependencies = { 'vim-denops/denops.vim' },
    event = 'VeryLazy',
  },
}
