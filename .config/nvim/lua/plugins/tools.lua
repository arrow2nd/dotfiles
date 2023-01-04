return {
  {
    'vim-jp/vimdoc-ja',
    lazy = false,
  },
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gclog' }
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
  }
}
