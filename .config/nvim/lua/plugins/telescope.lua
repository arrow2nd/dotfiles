local nmap = require('util.helper').nmap

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-ui-select.nvim',
      'Allianaab2m/telescope-kensaku.nvim',
      'nvim-telescope/telescope-file-browser.nvim'
    },
    cmd = 'Telescope',
    init = function()
      nmap(';f', '<CMD>Telescope find_files<CR>')
      nmap(';g', '<CMD>Telescope kensaku<CR>')
      nmap(';G', '<CMD>Telescope live_grep<CR>')
      nmap(';k', '<CMD>Telescope keymaps<CR>')
      nmap(';h', '<CMD>Telescope help_tags<CR>')
      nmap(';c', '<CMD>Telescope git_commits<CR>')
      nmap(';b', function()
        return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand('%:p:h') .. '<CR>'
      end, { silent = true, expr = true })
    end,
    config = function()
      local telescope = require('telescope')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
                  ['<C-j>'] = 'move_selection_next',
                  ['<C-k>'] = 'move_selection_previous',
                  ['<C-n>'] = 'cycle_history_next',
                  ['<C-p>'] = 'cycle_history_prev',
                  ['<C-q>'] = 'close',
            },
            n = {
                  ['q'] = 'close',
            },
          },
          prompt_prefix = ' ',
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              width = 0.8,
              height = 0.9,
              prompt_position = 'bottom',
            },
          },
          preview = { treesitter = false },
          file_ignore_patterns = { '^.git/' },
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
          find_files = { hidden = true },
          live_grep = {},
        },
        extensions = {
          file_browser = {
            hidden = true,
            respect_gitignore = false,
          },
        }
      })

      telescope.load_extension('ui-select')
      telescope.load_extension('kensaku')
      telescope.load_extension('file_browser')
    end
  }
}
