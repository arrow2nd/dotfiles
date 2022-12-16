local ok, telescope = pcall(require, 'telescope')
if (not ok) then return end

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ['<A-j>'] = 'move_selection_next',
        ['<A-k>'] = 'move_selection_previous',
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
