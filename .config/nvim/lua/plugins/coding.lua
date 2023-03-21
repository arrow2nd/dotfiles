local h = require('util.helper')
local api = vim.api

return {
  { 'vim-jp/vimdoc-ja',     lazy = false },
  { 'thinca/vim-qfreplace', cmd = 'Qfreplace' },
  { 'thinca/vim-quickrun',  cmd = 'QuickRun' },
  {
    'lambdalisue/gin.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      h.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>', { desc = 'Operate git status' })
      h.nmap('<Leader>gc', '<CMD>Gin commit<CR>', { desc = 'Operate git commit' })
      h.nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>', { desc = 'Show git diff' })
      h.nmap('<Leader>gl', '<CMD>GinLog ++opener=split<CR>', { desc = 'Show git log' })
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
    'vim-skk/skkeleton',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      h.imap('<C-j>', '<Plug>(skkeleton-enable)')
      h.cmap('<C-j>', '<Plug>(skkeleton-enable)')

      -- 辞書を探す
      local dictionaries = {}
      local handle = io.popen('ls $HOME/.skk/*') -- フルバスで取得
      if handle then
        for file in handle:lines() do
          table.insert(dictionaries, file)
        end
        handle:close()
      end

      api.nvim_create_autocmd('User', {
        pattern = 'skkeleton-initialize-pre',
        callback = function()
          vim.fn['skkeleton#config']({
            eggLikeNewline = true,
            registerConvertResult = true,
            globalDictionaries = dictionaries,
          })
        end
      })
    end,
  },
  {
    'skanehira/denops-translate.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
  }
}
