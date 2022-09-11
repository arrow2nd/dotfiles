local ok, telescope = pcall(require, 'telescope')

if (not ok) then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ['q'] = actions.close,
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
    extensions = {
      file_browser = {
        hijack_netrw = true,
      },
    },
  },
}

telescope.load_extension "file_browser"

local commonOptions = {
 hidden = true,
}

vim.keymap.set('n', '<Leader>ff',
  function()
    builtin.find_files(commonOptions)
  end
)

vim.keymap.set('n', '<Leader>fg',
  function()
    builtin.live_grep(commonOptions)
  end
)

vim.keymap.set('n', '<Leader>fb',
  function()
   telescope.extensions.file_browser.file_browser(commonOptions)
  end
)

vim.keymap.set('n', '<Leader>fc',
  function()
    builtin.git_commits()
  end
)

vim.keymap.set('n', '<Leader>fs',
  function()
    builtin.git_status()
  end
)

