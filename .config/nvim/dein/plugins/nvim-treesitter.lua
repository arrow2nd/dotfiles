local ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not ok then return end

treesitter.setup {
  autotag = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = function(_, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local _ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if _ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  indent = {
    enable = true
  },
  ensure_installed = {
    'bash',
    'c',
    'comment',
    'cpp',
    'css',
    'dart',
    'dockerfile',
    'go',
    'gomod',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'php',
    'prisma',
    'python',
    'regex',
    'rust',
    'scss',
    'sparql',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'yaml',
  }
}
