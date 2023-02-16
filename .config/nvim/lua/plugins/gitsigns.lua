return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      local h = require('util.helper')
      h.nmap('<Leader>hb', '<CMD>Gitsigns blame_line<CR>', { desc = 'Show git blame on the current line' })
      h.nmap('<Leader>hp', '<CMD>Gitsigns preview_hunk<CR>', { desc = 'Show preview the hunk' })
      h.nmap('<Leader>hs', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Stage the hunk' })
      h.nmap('<Leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Undo the last call of stage hunk' })
      h.nmap('<Leader>hr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Reset the lines of the hunk' })
    end,
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '*' },
          delete = { text = '-' },
          topdelete = { text = '-' },
          changedelete = { text = '*' },
        },
      })
    end
  }
}
