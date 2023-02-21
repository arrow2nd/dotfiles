local h = require('util.helper')
local api = vim.api

return {
  {
    'vim-denops/denops.vim',
    event = 'VeryLazy',
  },
  {
    'rbtnn/vim-ambiwidth',
  },
  {
    'vim-jp/vimdoc-ja',
    lazy = false,
  },
  {
    'lambdalisue/gin.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'yuki-yano/denops-lazy.nvim'
    },
    cmd = { 'Gin', 'GinStatus', 'GinDiff', 'GinLog', 'GinChaperon' },
    init = function()
      h.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>', { desc = 'Operate git status' })
      h.nmap('<Leader>gc', '<CMD>Gin commit<CR>', { desc = 'Operate git commit' })
      h.nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>', { desc = 'Show git diff' })
      h.nmap('<Leader>gl', '<CMD>GinLog ++opener=split<CR>', { desc = 'Show git log' })
    end,
    config = function()
      require('denops-lazy').load('gin.vim')
    end
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = true,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'terrortylor/nvim-comment',
    event = 'InsertEnter',
    config = function()
      require('nvim_comment').setup()
    end
  },
  {
    'kylechui/nvim-surround',
    event = 'BufReadPost',
    config = true,
  },
  {
    'thinca/vim-qfreplace',
    cmd = 'Qfreplace',
  },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' },
    init = function()
      api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end,
    config = function()
      require('peek').setup({
        auto_load = true,
        close_on_bdelete = true,
        syntax = true,
        theme = 'dark',
        update_on_change = true,
        app = 'browser',
        throttle_at = 200000,
        throttle_time = 'auto',
      })
    end
  },
  {
    'monaqa/dial.nvim',
    keys = { '<C-a>', '<C-x>' },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.date.alias['%Y/%m/%d'],
          augend.date.alias['%Y-%m-%d'],
          augend.date.alias['%Y年%m月%d日'],
          augend.date.alias['%m月%d日'],
        }
      })

      h.nmap('<C-a>', require('dial.map').inc_normal(), { noremap = true })
      h.nmap('<C-x>', require('dial.map').dec_normal(), { noremap = true })
    end
  },
  {
    'yuki-yano/fuzzy-motion.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'lambdalisue/kensaku.vim',
      'yuki-yano/denops-lazy.nvim'
    },
    cmd = 'FuzzyMotion',
    init = function()
      h.nmap('<Leader><Space>', '<CMD>FuzzyMotion<CR>')
      vim.g.fuzzy_motion_matchers = { 'fzf', 'kensaku' }
    end,
    config = function()
      require('denops-lazy').load('kensaku.vim')
      require('denops-lazy').load('fuzzy-motion.vim')
    end
  },
  {
    'vim-skk/skkeleton',
    event = 'VeryLazy',
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      h.imap('<C-j>', '<Plug>(skkeleton-enable)')
      h.cmap('<C-j>', '<Plug>(skkeleton-enable)')

      api.nvim_create_autocmd('User', {
        pattern = 'skkeleton-initialize-pre',
        callback = function()
          vim.fn['skkeleton#config']({
            eggLikeNewline = true,
            skkServerPort = 1178,
            useSkkServer = true,
          })
        end
      })
    end,
  },
  {
    'lambdalisue/butler.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'yuki-yano/denops-lazy.nvim'
    },
    cmd = 'Butler',
    config = function()
      require('denops-lazy').load('butler.vim')
    end
  },
  {
    'skanehira/denops-translate.vim',
    dependencies = {
      'vim-denops/denops.vim',
      'yuki-yano/denops-lazy.nvim'
    },
    cmd = 'Translate',
    config = function()
      require('denops-lazy').load('denops-translate.vim')
    end
  }
}
