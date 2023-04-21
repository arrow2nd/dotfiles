local nmap = require('util.helper').nmap

return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      nmap('<C-k>', '<CMD>Gitsigns blame_line<CR>', { desc = 'Show git blame on the current line' })
      nmap('<Leader>hp', '<CMD>Gitsigns preview_hunk<CR>', { desc = 'Show preview the hunk' })
      nmap('<Leader>hs', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Stage the hunk' })
      nmap('<Leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Undo the last call of stage hunk' })
      nmap('<Leader>hr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Reset the lines of the hunk' })
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
        preview_config = {
          border = 'none',
          style = 'minimal',
        },
      })
    end
  }
}
