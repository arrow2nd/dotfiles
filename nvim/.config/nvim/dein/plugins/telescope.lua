local ok, telescope = pcall(require, 'telescope')

if (not ok) then return end

local builtin = require('telescope.builtin')
local helper = require('helper')

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

helper.nmap('<Leader>ff',
  function()
    builtin.find_files(commonOptions)
  end
)

helper.nmap('<Leader>fg',
  function()
    builtin.live_grep(commonOptions)
  end
)

helper.nmap('<Leader>fc',
  function()
    builtin.git_commits()
  end
)

-- file_browser
telescope.load_extension "file_browser"

helper.nmap('<C-f>',
  function()
    telescope.extensions.file_browser.file_browser(commonOptions)
  end
)

helper.nmap('<C-n>',
  function()
    telescope.extensions.file_browser.file_browser({
      hidden = true,
      cwd = vim.fn.expand('%:p:h'),
    })
  end
)
