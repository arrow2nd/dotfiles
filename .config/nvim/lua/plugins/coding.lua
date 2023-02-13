local h = require('util.helper')

return {
  {
    'vim-jp/vimdoc-ja',
    lazy = false,
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gclog' },
    init = function()
      h.nmap('<Leader>gs', '<CMD>Git<CR>', { desc = 'Operate git status' })
      h.nmap('<Leader>gd', '<CMD>Gdiffsplit<CR>', { desc = 'Show git diff' })
      h.nmap('<Leader>gc', '<CMD>Git commit<CR>', { desc = 'Operate git commit' })
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
    'tpope/vim-commentary',
    event = 'InsertEnter'
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
    },
    cmd = 'FuzzyMotion',
    init = function()
      h.nmap('<Leader>fm', '<CMD>FuzzyMotion<CR>')
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
    end,
  },
  {
    'skanehira/denops-translate.vim',
    dependencies = { 'vim-denops/denops.vim' },
    cmd = 'Translate',
    config = function()
      require('denops-lazy').setup('denops-translate.vim')
    end
  },
  {
    'lambdalisue/butler.vim',
    dependencies = { 'vim-denops/denops.vim' },
    event = 'VeryLazy',
  },
  {
    'iamcco/markdown-preview.nvim',
    build = 'sh -c "cd app && npm install"',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' }
  },
}
