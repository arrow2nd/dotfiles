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

local biomefmt = {
  formatCommand = "biome check --apply --stdin-file-path '${INPUT}'",
  formatStdin = true,
  requireMarker = true,
  rootMarkers = { "rome.json", "biome.json" },
}

local denofmt = {
  formatCommand = "deno fmt --ext ${FILEEXT} -",
  formatStdin = true,
}

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
  cmd = { 'efm-langserver' },
  settings = {
    languages = {
      html = { prettier },
      css = { prettier },
      scss = { prettier },
      javascript = { prettier, denofmt, biomefmt },
      javascriptreact = { prettier, biomefmt, denofmt },
      typescript = { prettier, biomefmt, denofmt },
      typescriptreact = { prettier, biomefmt },
      json = { prettier, denofmt },
      jsonc = { prettier, denofmt },
      yaml = { prettier },
      markdown = { prettier, denofmt, textlint },
      lua = { stylua },
    }
  },
}
