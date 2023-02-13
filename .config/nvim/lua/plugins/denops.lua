return {
    {
        'vim-denops/denops.vim',
        event = 'VeryLazy',
    },
    {
        'yuki-yano/denops-lazy.nvim',
        config = function()
          require('denops-lazy').setup()
        end
    },
}
