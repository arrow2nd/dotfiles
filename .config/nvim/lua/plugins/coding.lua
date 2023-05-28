local h = require('util.helper')

return {
  { 'vim-jp/vimdoc-ja',     lazy = false },
  { 'thinca/vim-qfreplace', cmd = 'Qfreplace' },
  { 'thinca/vim-quickrun',  cmd = 'QuickRun' },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = true,
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
  },
  {
    'kat0h/bufpreview.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
    build = 'deno task prepare',
  },
  {
    'voldikss/vim-floaterm',
    cmd = { 'FloatermNew', 'FloatermToggle', 'FloatermSend' },
    init = function()
      h.nmap('<Leader>ff', '<Cmd>FloatermToggle<CR>')
      h.nmap('<Leader>fn', '<Cmd>FloatermNew<CR>')
      h.nmap('<Leader>fc', '<Cmd>FloatermKill<CR>')
      h.nmap(']f', '<Cmd>FloatermNext<CR>')
      h.nmap('[f', '<Cmd>FloatermPrev<CR>')
      h.tmap('<C-q>', '<Cmd>FloatermHide<CR>')
    end,
    config = function()
      vim.g.floaterm_title = '  ($1/$2) '
      vim.api.nvim_set_hl(0, "FloatermBorder", { link = "Normal" })
    end
  },
}
