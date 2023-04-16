local imap = require('util.helper').imap
local fn = vim.fn

return {
  {
    'Shougo/ddc.vim',
    lazy = false,
    dependencies = {
      'vim-denops/denops.vim',
      -- UI
      'Shougo/pum.vim',
      'Shougo/ddc-ui-pum',
      -- Source
      'Shougo/ddc-source-around',
      'Shougo/ddc-source-nvim-lsp',
      'LumaKernel/ddc-source-file',
      -- Matcher
      'Shougo/ddc-matcher_head',
      'Shougo/ddc-matcher_length',
      -- Sorter
      'Shougo/ddc-sorter_rank',
      -- Converter
      'Shougo/ddc-converter_remove_overlap',
      -- Preview
      'matsui54/denops-popup-preview.vim',
      'matsui54/denops-signature_help',
    },
    config = function()
      local patch_global = fn['ddc#custom#patch_global']

      patch_global('ui', 'pum')

      patch_global('sources', {
        'skkeleton',
        'vsnip',
        'nvim-lsp',
        'file',
        'around',
      })

      patch_global('sourceOptions', {
        _ = {
          matchers = { 'matcher_head', 'matcher_length' },
          sorters = { 'sorter_rank' },
          converters = { 'converter_remove_overlap' },
          ignoreCase = true,
        },
        around = { mark = '[A]' },
        ['nvim-lsp'] = {
          mark = '[LS]',
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
        },
        vsnip = { dup = 'keep' },
        file = {
          mark = '[F]',
          isVolatile = true,
          forceCompletionPattern = [[\S/\S*]],
        },
        skkeleton = {
          mark = '[SKK]',
          matchers = { 'skkeleton' },
          sorters = {},
          isVolatile = true,
          minAutoCompleteLength = 2,
        },
      })

      -- keymap
      local opts = { silent = true, noremap = true }
      imap('<c-n>', '<Cmd>call pum#map#select_relative(+1)<CR>', opts)
      imap('<c-p>', '<Cmd>call pum#map#select_relative(-1)<CR>', opts)

      fn['ddc#enable']()
    end,
  },
  {
    'Shougo/pum.vim',
    config = function()
      fn['pum#set_option']({
        auto_select = true,
        padding = true,
        max_horizontal_items = 3,
      })

      -- keymaps
      local opts = { silent = true, noremap = true }
      imap('<C-y>', '<Cmd>call pum#map#confirm()<CR>', opts)
      imap('<C-e>', '<Cmd>call pum#map#cancel()<CR>', opts)
    end
  },
  {
    'matsui54/denops-popup-preview.vim',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      vim.g.popup_preview_config = {
        border = true,
        supportVsnip = true,
        supportUltisnips = false,
        supportInfo = true,
        delay = 80,
      }

      fn['popup_preview#enable']()
    end
  },
  {
    'matsui54/denops-signature_help',
    dependencies = { 'vim-denops/denops.vim' },
    config = function()
      vim.g.signature_help_config = {
        contentsStyle = 'currentLabel',
        viewStyle = 'virtual',
      }

      fn['signature_help#enable']()
    end
  },
  {
    'hrsh7th/vim-vsnip',
    lazy = false,
    dependencies = { 'hrsh7th/vim-vsnip-integ' },
    config = function()
      vim.g.vsnip_snippet_dir = '~/.config/vsnip'
      vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
      vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')

      -- 補完確定時に textEdit を適応
      vim.api.nvim_create_autocmd('User', {
        pattern = 'PumCompleteDone',
        callback = function()
          fn['vsnip_integ#on_complete_done'](vim.g['pum#completed_item'])
        end
      })
    end
  }
}
