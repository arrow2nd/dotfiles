local M = {
  'nvim-telescope/telescope.nvim',
  version = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'kyazdani42/nvim-web-devicons',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope-file-browser.nvim'
  },
  cmd = 'Telescope'
}

function M.config()
  local telescope = require('telescope')

  telescope.setup {
    defaults = {
      mappings = {
        i = {
          ['<C-n>'] = 'cycle_history_next',
          ['<C-p>'] = 'cycle_history_prev',
          ['<ESC><ESC>'] = 'close',
        },
        n = {
          ['<ESC><ESC>'] = 'close',
        },
      },
      layout_config = {
        horizontal = {
          width = 0.9,
        },
      },
      file_ignore_patterns = {
        '^.git/',
      },
      vimgrep_arguments = {
        'rg',
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--hidden',
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {},
    },
    extensions = {
      file_browser = {
        hidden = true,
        respect_gitignore = false,
      },
    }
  }

  telescope.load_extension("file_browser")
end

return M
