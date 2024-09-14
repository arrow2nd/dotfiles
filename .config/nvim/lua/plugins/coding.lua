local h = require("util.helper")

return {
  {
    "vim-jp/vimdoc-ja",
    lazy = false,
  },
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
    "skanehira/denops-translate.vim",
    lazy = false,
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
