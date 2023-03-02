local nmap = require('util.helper').nmap

return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-file-browser.nvim'
    },
    cmd = 'Telescope',
    init = function()
      nmap('<Leader>ff', '<CMD>Telescope find_files<CR>')
      nmap('<Leader>fg', '<CMD>Telescope live_grep<CR>')
      nmap('<Leader>fb', '<CMD>Telescope buffers<CR>')
      nmap('<Leader>fr', '<CMD>Telescope registers<CR>')
      nmap('<Leader>fk', '<CMD>Telescope keymaps<CR>')
      nmap('<Leader>fh', '<CMD>Telescope help_tags<CR>')
      nmap('<Leader>fc', '<CMD>Telescope git_commits<CR>')
      nmap('<Leader>bb', function()
        return '<CMD>Telescope file_browser cwd=' .. vim.fn.expand('%:p:h') .. '<CR>'
      end, { silent = true, expr = true })
    end,
    config = function()
      local telescope = require('telescope')

      telescope.setup({
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
            horizontal = { width = 0.9 },
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
      })

      telescope.load_extension('file_browser')
    end
  }
}
