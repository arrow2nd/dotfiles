local function get_lsp_progress()
  local prog = vim.lsp.util.get_progress_messages()[1]
  if not prog then return '' end

  local title = prog.title or ''
  local per = prog.percentage or 0

  return string.format('%s (%s%%%%)', title, per)
end

return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '|', right = '|' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diff',
            { 'diagnostics', sources = { 'nvim_lsp' } },
          },
          lualine_c = { 'filename' },
          lualine_x = { get_lsp_progress },
          lualine_y = { 'fileformat', 'encoding' },
          lualine_z = { 'location' }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = {},
          lualine_y = { 'fileformat', 'encoding', 'location' },
          lualine_z = {}
        },
        tabline = {},
        extensions = {}
      })
    end
  }
}
