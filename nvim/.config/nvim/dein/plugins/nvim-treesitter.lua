require('nvim-treesitter.configs').setup {
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
