local ok, telescope = pcall(require, 'telescope')

if (not ok) then return end

local builtin = require("telescope.builtin")

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,
      },
    },
  },
  pickers = {},
  extensions = {}
}

vim.keymap.set('n', '<Leader>ff',
  function()
    builtin.find_files()
  end
)

vim.keymap.set('n', '<Leader>fg',
  function()
    builtin.live_grep()
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

