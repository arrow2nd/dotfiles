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
      h.nmap('<Leader>gs', '<CMD>Git<CR>', { desc = "Operate git status" })
      h.nmap('<Leader>gd', '<CMD>Gdiffsplit<CR>', { desc = "Show git diff" })
      h.nmap('<Leader>gc', '<CMD>Git commit<CR>', { desc = "Operate git commit" })
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
    'iamcco/markdown-preview.nvim',
    build = 'sh -c "cd app && yarn install"',
    ft = { 'markdown', 'pandoc.markdown', 'rmd' }
  },
  {
    'skanehira/denops-translate.vim',
    dependencies = { 'vim-denops/denops.vim' },
    cmd = 'Translate',
    init = function()
      h.vmap('<Leader>tl', '<Plug>(Translate)', { desc = "Translates the selected area" })
    end
  }
}
