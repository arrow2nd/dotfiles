local rootMarkers = {
  prettier = {
    ".prettierrc",
    ".prettierrc.js",
    ".prettierrc.mjs",
    ".prettierrc.cjs",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
  },
  biome = {
    "biome.json",
  },
  stylua = {
    "stylua.toml",
    ".stylua.toml",
  },
  textlint = {
    ".textlintrc",
    ".textlintrc.yml",
    ".textlintrc.yaml",
    ".textlintrc.json",
  },
}

local prettier = {
  formatCommand = "node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
  formatStdin = true,
  requireMarker = true,
  rootMarkers = rootMarkers.prettier,
}

local denofmt = {
  formatCommand = "deno fmt --ext ${FILEEXT} -",
  formatStdin = true,
}

-- Prettier / biome / denofmt の出し分け
local lspconfig = require("lspconfig")
local prettier_rootdir = lspconfig.util.root_pattern(rootMarkers.prettier)
local biome_rootdir = lspconfig.util.root_pattern(rootMarkers.biome)

local denofmt_or_prettier = denofmt
local cwd = vim.fn.getcwd()

if prettier_rootdir(cwd) then
  -- Prettier の設定がある場合は Prettier を使う
  denofmt_or_prettier = prettier
elseif biome_rootdir(cwd) then
  -- biome の設定がある場合は無効に
  denofmt_or_prettier = nil
end

local stylua = {
  formatCommand = "stylua --color Never -",
  formatStdin = true,
  requireMarker = true,
  rootMarkers = rootMarkers.stylua,
}

local textlint = {
  lintCommand = "node_modules/.bin/textlint --no-color --format compact --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {
    "%.%#: line %l, col %c, %trror - %m",
    "%.%#: line %l, col %c, %tarning - %m",
  },
  requireMarker = true,
  rootMarkers = rootMarkers.textlint,
}

return {
  init_options = {
    documentFormatting = true,
    hover = true,
    codeAction = true,
  },
  cmd = { "efm-langserver" },
  settings = {
    languages = {
      html = { prettier },
      css = { prettier },
      scss = { prettier },
      javascript = { denofmt_or_prettier },
      javascriptreact = { denofmt_or_prettier },
      typescript = { denofmt_or_prettier },
      typescriptreact = { denofmt_or_prettier },
      json = { denofmt_or_prettier },
      jsonc = { denofmt_or_prettier },
      yaml = { prettier },
      markdown = { denofmt_or_prettier, textlint },
      lua = { stylua },
    },
  },
}
