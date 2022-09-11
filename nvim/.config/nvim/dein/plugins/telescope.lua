local ok, telescope = pcall(require, 'telescope')

if (not ok) then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close,
      },
    },
    layout_config = {
      horizontal = {
        width = 0.9,
      },
    },
    file_ignore_patterns = {
      '^.git/',
    }
  },
}

vim.keymap.set('n', '<Leader>ff',
  function()
    builtin.find_files({
      hidden = true,
    })
  end
)

vim.keymap.set('n', '<Leader>fg',
  function()
    builtin.live_grep({
      hidden = true,
    })
  end
)

vim.keymap.set('n', '<Leader>fb',
  function()
    builtin.buffers()
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

