local h = require("util.helper")

return {
  {
    "vim-jp/vimdoc-ja",
    lazy = false,
  },
  { "nvim-tree/nvim-web-devicons" },
  {
    "vim-denops/denops.vim",
    priority = 500, -- 大体のプラグインが依存しているので優先して読み込む
    lazy = false,
  },
  {
    "thinca/vim-qfreplace",
    cmd = "Qfreplace",
  },
  {
    "thinca/vim-quickrun",
    cmd = "QuickRun",
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "InsertEnter",
    init = function()
      -- ref: https://github.com/JoosepAlviste/nvim-ts-context-commentstring/wiki/Integrations#native-commenting-in-neovim-010
      local get_option = vim.filetype.get_option

      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })
    end,
  },
  {
    "skanehira/denops-translate.vim",
    lazy = false,
    init = function()
      h.xmap("<Leader>t", "<Plug>(Translate)")
    end,
  },
  {
    "kat0h/bufpreview.vim",
    lazy = false,
    build = "deno task prepare",
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    init = function()
      h.nmap("<Leader><Space>", "<Cmd>ToggleTerm<CR>")
    end,
    config = true,
  },
}
