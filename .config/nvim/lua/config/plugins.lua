return {
  {
    "arrow2nd/minai",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("minai")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },
  "vim-jp/vimdoc-ja",
  "nvim-lua/plenary.nvim",
  {
    "echasnovski/mini.nvim",
    config = function()
      require("config.mini")
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("config.fzf")
    end,
  },
  {
    "WataruNishimura/git-wt.nvim",
    dependencies = { "ibhagwan/fzf-lua" },
    opts = {},
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("config.toggleterm")
    end,
  },
  {
    "tkmpypy/chowcho.nvim",
    config = function()
      require("config.chowcho")
    end,
  },
  { "windwp/nvim-ts-autotag", opts = {} },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    main = "ts_context_commentstring",
    opts = { enable_autocmd = false },
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "monaqa/dial.nvim",
    config = function()
      require("config.dial")
    end,
  },
  {
    "uga-rosa/translate.nvim",
    config = function()
      require("config.translate")
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = { "markdown" },
    -- 上流の lockfile を書き換えると、次回のプラグイン更新を妨げるため保存しない。
    build = "cd app && npm install --no-save --package-lock=false",
  },
  {
    "folke/sidekick.nvim",
    config = function()
      require("config.sidekick")
    end,
  },
  {
    "ggml-org/llama.vim",
    init = function()
      require("config.llama")
    end,
  },
  { "esmuellert/codediff.nvim", cmd = { "CodeDiff" } },
  { "thinca/vim-qfreplace", cmd = { "Qfreplace" } },
  {
    "rhysd/git-messenger.vim",
    cmd = { "GitMessenger" },
    init = function()
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig", "saghen/blink.cmp" },
    config = function()
      require("config.lsp")
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "hrsh7th/vim-vsnip", "kjuq/skkelua.nvim" },
    config = function()
      require("config.blink")
    end,
  },
  {
    "hrsh7th/vim-vsnip",
    init = function()
      vim.g.vsnip_snippet_dir = "~/.config/vsnip"
      vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
      vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
    end,
  },
  {
    "kjuq/skkelua.nvim",
    config = function()
      require("config.skk")
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    opts = {
      floating_window = false,
      hint_enable = true,
      hint_prefix = "",
    },
  },
}
