local ok, telescope = pcall(require, 'telescope')

if (not ok) then return end

local builtin = require('telescope.builtin')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ['<C-j>'] = 'move_selection_next',
        ['<C-k>'] = 'move_selection_previous',
        ['<C-l>'] = 'select_default',
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
    extensions = {
      file_browser = {
        hijack_netrw = true,
      },
    },
  }
}

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

-- file_browser
telescope.load_extension "file_browser"

vim.keymap.set('n', '<C-n>',
  function()
    telescope.extensions.file_browser.file_browser({
      hidden = true,
      cwd = vim.fn.expand('%:p:h'),
    })
  end
)

