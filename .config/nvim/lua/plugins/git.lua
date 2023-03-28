local h = require('util.helper')

return {
  {
    'lambdalisue/gin.vim',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim' },
    init = function()
      h.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>', { desc = 'Operate git status' })
      h.nmap('<Leader>gc', '<CMD>Gin commit<CR>', { desc = 'Operate git commit' })
      h.nmap('<Leader>gl', '<CMD>GinLog ++opener=split<CR>', { desc = 'Show git log' })
    end
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    init = function()
      h.nmap('<Leader>gd', '<CMD>DiffviewOpen<CR>', { desc = 'Show git diff' })
      h.nmap('<Leader>gh', '<CMD>DiffviewFileHistory %<CR>', { desc = 'Show current file history' })
      h.nmap('<Leader>gH', '<CMD>DiffviewFileHistory<CR>', { desc = 'Show current branch file history' })
    end,
    config = function()
      require("diffview").setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
      })
    end
  },

}
