local ok, telescope = pcall(require, 'telescope')
if (not ok) then return end

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<C-l>'] = 'select_default',
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
  },
  pickers = {
    find_files = {
      hidden = true,
    },
    live_grep = {
      glob_pattern = {
        '*',
        '!.git/*',
        '!.yarn/*',
        '!node_modules/*',
      },
    },
  },
  extensions = {
    file_browser = {
      hidden = true,
      mappings = {
        i = {
          ['<C-n>'] = 'close',
        },
        n = {
          ['<C-n>'] = 'close',
        },
      },
    },
  }
}

telescope.load_extension("file_browser")
