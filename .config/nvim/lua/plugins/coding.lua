local h = require('util.helper')

return {
  { 'vim-jp/vimdoc-ja',     lazy = false },
  { 'thinca/vim-qfreplace', cmd = 'Qfreplace' },
  { 'thinca/vim-quickrun',  cmd = 'QuickRun' },
  {
    'seblj/nvim-tabline',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    config = function()
      require('tabline').setup({
        no_name = '[No Name]',
        modified_icon = '*',
        show_icon = true,
        color_all_icons = true,
        separator = '',
        padding = 2,
      })
    end
  },
  {
    'norcalli/nvim-colorizer.lua',
    event = 'BufRead',
    config = function()
      require('colorizer').setup()
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
    'numToStr/Comment.nvim',
    event = 'InsertEnter',
    config = true,
  },
  {
    'kylechui/nvim-surround',
    event = 'BufReadPost',
    config = true,
  },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' },
    init = function()
      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
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
    lazy = false,
    dependencies = {
      'vim-denops/denops.vim',
      'lambdalisue/kensaku.vim',
    },
    init = function()
      h.nmap('<Leader><Space>', '<CMD>FuzzyMotion<CR>')
      vim.g.fuzzy_motion_matchers = { 'fzf', 'kensaku' }
    end
  },
  {
    'skanehira/denops-translate.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
  }
}
