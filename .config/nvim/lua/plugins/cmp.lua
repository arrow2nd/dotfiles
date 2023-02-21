local h = require('util.helper')
local fn = vim.fn

return {
  {
    'Shougo/ddc.vim',
    event = 'InsertEnter',
    dependencies = {
      'vim-denops/denops.vim',
      'yuki-yano/denops-lazy.nvim',
      -- UI
      'Shougo/pum.vim',
      'Shougo/ddc-ui-pum',
      -- Source
      'Shougo/ddc-source-around',
      'Shougo/ddc-source-nvim-lsp',
      -- Matcher
      'Shougo/ddc-matcher_head',
      'Shougo/ddc-matcher_length',
      -- Sorter
      'Shougo/ddc-sorter_rank',
      -- Converter
      'Shougo/ddc-converter_remove_overlap',
    },
    config = function()
      require('denops-lazy').load('ddc.vim')
      local patch_global = fn['ddc#custom#patch_global']

      patch_global('sources', {
        'skkeleton',
        'vsnip',
        'nvim-lsp',
        'around',
      })

      patch_global('sourceOptions', {
        _ = {
          matchers = { 'matcher_head', 'matcher_length' },
          sorters = { 'sorter_rank' },
          converters = { 'converter_remove_overlap' },
        },
        around = { mark = '[A]' },
        ['nvim-lsp'] = {
          mark = '[LS]',
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        },
        vsnip = {
          dup = 'keep',
        },
        skkeleton = {
          mark = '[SKK]',
          matchers = { 'skkeleton' },
          sorters = {},
          isVolatile = true,
          minAutoCompleteLength = 2,
        },
      })

      patch_global('ui', 'pum')

      -- keymap
      local opts = { silent = true, expr = true, noremap = true }
      h.imap('<Tab>',
        [[pum#visible() ? pum#map#insert_relative(+1) : '<Tab>']],
        opts
      )
      h.imap('<S-Tab>',
        [[pum#visible() ? pum#map#insert_relative(-1) : '<S-TAB>']],
        opts
      )

      fn['ddc#enable']()
    end,
  },
  {
    'Shougo/pum.vim',
    config = function()
      local opts = { silent = true, noremap = true }
      h.imap('<C-y>', '<Cmd>call pum#map#confirm()<CR>', opts)
      h.imap('<C-e>', '<Cmd>call pum#map#cancel()<CR>', opts)
    end
  },
  {
    'matsui54/denops-popup-preview.vim',
    event = 'BufReadPre',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      require('denops-lazy').load('denops-popup-preview.vim')

      vim.g.popup_preview_config = {
        delay = 30,
        supportUltisnips = false,
        supportInfo = true,
      }

      fn['popup_preview#enable']()
    end
  },
  {
    'matsui54/denops-signature_help',
    event = 'BufReadPre',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      require('denops-lazy').load('denops-signature_help')

      vim.g.signature_help_config = {
        contentsStyle = 'currentLabel',
        viewStyle = 'virtual',
      }

      fn['signature_help#enable']()
    end
  },
  {
    'hrsh7th/vim-vsnip',
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/vim-vsnip-integ' },
    config = function()
      vim.g.vsnip_snippet_dir = '~/.config/vsnip'

      -- NOTE: `h.imap() の形式で書くと、ジャンプしようとした際に `vsnip~` が入力されてしまうので vim.cmd を使ってる
      vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
      vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
    end
  }
}
