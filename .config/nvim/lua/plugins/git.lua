local h = require("util.helper")

return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      h.nmap("<Leader>hp", "<CMD>Gitsigns preview_hunk<CR>", { desc = "Show preview the hunk" })

      for _, mode in pairs({ "n", "v" }) do
        local key = mode .. "map"
        h[key]("<Leader>hs", "<CMD>Gitsigns stage_hunk<CR>", { desc = "Stage the hunk" })
        h[key]("<Leader>hu", "<CMD>Gitsigns undo_stage_hunk<CR>", { desc = "Undo the last call of stage hunk" })
        h[key]("<Leader>hr", "<CMD>Gitsigns reset_hunk<CR>", { desc = "Reset the lines of the hunk" })
      end
    end,
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "*" },
          delete = { text = "-" },
          topdelete = { text = "-" },
          changedelete = { text = "*" },
        },
        preview_config = {
          border = "single",
          style = "minimal",
        },
      })
    end,
  },
  {
    "rhysd/git-messenger.vim",
    cmd = "GitMessenger",
    init = function()
      h.nmap("<C-k>", "<CMD>GitMessenger<CR>", { desc = "Show git blame on the current line" })
      vim.g.git_messenger_floating_win_opts = { border = "single" }
    end,
  },
}
