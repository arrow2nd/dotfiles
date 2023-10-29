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
    "pechorin/any-jump.vim",
    cmd = { "AnyJump", "AnyJumpVisual", "AnyJumpBack", "AnyJumpLastResults" },
    init = function()
      vim.g.any_jump_grouping_enabled = 1
      vim.g.any_jump_disable_default_keybindings = 1

      h.nmap("<Leader>j", "<Cmd>AnyJump<CR>")
      h.xmap("<Leader>j", "<Cmd>AnyJumpVisual<CR>")
      h.nmap("<Leader>l", "<Cmd>AnyJumpLastResults<CR>")
    end,
  },
}
