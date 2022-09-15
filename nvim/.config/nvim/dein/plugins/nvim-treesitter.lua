local ok, treesitter = pcall(require, 'nvim-treesitter.configs')

if (not ok) then return end

treesitter.setup {
  highlight = {
    enable = true,
    disable = {},
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
    'go',
    'gomod',
    'html',
    'javascript',
    'jsdoc',
    'json',
    'jsonc',
    'lua',
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
