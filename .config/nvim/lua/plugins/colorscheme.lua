return {
  {
    "cocopon/iceberg.vim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme iceberg]])
      vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
      vim.cmd([[hi Comment gui=italic]])
    end,
  },
  {
    "arrow2nd/aqua.vim",
    -- dir = "~/workspace/github.com/arrow2nd/aqua.vim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme aqua]])
    end,
  },
}
