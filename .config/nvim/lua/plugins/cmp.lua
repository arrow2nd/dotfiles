return {
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter' },
        dependencies = {
            'onsails/lspkind.nvim',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
        },
        config = function()
          local cmp = require('cmp')
          local lspkind = require('lspkind')

          cmp.setup({
              snippet = {
                  expand = function(args)
                    vim.fn['vsnip#anonymous'](args.body)
                  end,
              },
              sources = cmp.config.sources({
                  { name = 'path' },
                  { name = 'nvim_lsp' },
                  { name = 'vsnip' },
              }, {
                  { name = 'buffer' },
              }),
              formatting = {
                  format = lspkind.cmp_format({
                      mode = 'symbol_text',
                      menu = ({
                          buffer = '[Buffer]',
                          path = '[Path]',
                          nvim_lsp = '[LSP]',
                          vsnip = '[Snip]',
                      })
                  }),
              },
              mapping = cmp.mapping.preset.insert({
                  ['<S-TAB>'] = cmp.mapping.select_prev_item(),
                  ['<TAB>'] = cmp.mapping.select_next_item(),
                  ['<CR>'] = cmp.mapping.abort(),
                  ['<C-y>'] = cmp.mapping.confirm { select = true },
              }),
              experimental = { ghost_text = true },
          })

          cmp.setup.cmdline({ '/', '?' }, {
              mapping = cmp.mapping.preset.cmdline(),
              sources = {
                  { name = 'buffer' }
              }
          })
        end
    },
    {
        'hrsh7th/vim-vsnip',
        event = 'InsertEnter',
        config = function()
          vim.g.vsnip_snippet_dir = '~/.config/vsnip'
          vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
          vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
          vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
          vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
        end
    }
}
