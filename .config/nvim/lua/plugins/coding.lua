local h = require("util.helper")

return {
  { "vim-jp/vimdoc-ja", lazy = false },
  { "thinca/vim-qfreplace", cmd = "Qfreplace" },
  { "thinca/vim-quickrun", cmd = "QuickRun" },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = true,
  },
  {
    "skanehira/denops-translate.vim",
    lazy = false,
    dependencies = { "vim-denops/denops.vim" },
  },
  {
    "kat0h/bufpreview.vim",
    lazy = false,
    dependencies = { "vim-denops/denops.vim" },
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
  {
    "github/copilot.vim",
    enabled = os.getenv("ENABLED_COPILOT") == "1",
    lazy = false,
    config = function()
      vim.api.nvim_set_keymap("i", "<C-CR>", 'copilot#Accept("\\<CR>")', {
        noremap = true,
        expr = true,
        silent = true,
      })

      vim.g.copilot_no_maps = true
    end,
  },
}
