local lsp = require("util.lsp")
local h = require("util.helper")

local efm_opts = function()
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
    rootMarkers = rootMarkers.stylua,
  }

  local textlint = {
    lintCommand = "node_modules/.bin/textlint --no-color --format compact --stdin --stdin-filename ${INPUT}",
    lintStdin = true,
    lintFormats = {
      "%.%#: line %l, col %c, %trror - %m",
      "%.%#: line %l, col %c, %tarning - %m",
    },
    rootMarkers = rootMarkers.textlint,
  }

  local languages = {
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
  }

  return {
    init_options = {
      documentFormatting = true,
      hover = true,
      codeAction = true,
    },
    filetypes = vim.tbl_keys(languages),
    settings = { languages = languages },
  }
end

-- LTSのNodeを使うように
local home_dir = vim.fn.expand("$HOME")
local node_bin = "/.local/share/mise/installs/node/lts/bin"

vim.g.node_host_prog = home_dir .. node_bin .. "/node"
vim.cmd("let $PATH = '" .. home_dir .. node_bin .. ":' . $PATH")

-- ポップアップウィンドウのボーダースタイルを設定
vim.diagnostic.config({
  float = {
    border = "single",
  },
})

require("mason").setup({
  ui = {
    border = "single",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "astro",
    "efm",
    "denols",
    "gopls",
    "ts_ls",
    "volar",
    "lua_ls",
    "yamlls",
    "jsonls",
    "rust_analyzer",
    "cssls",
    "eslint",
    "biome",
    "typos_lsp",
  },
  automatic_installation = true,
})

--  client_capabilities と forceCompletionPattern を設定
require("ddc_source_lsp_setup").setup()

local lspconfig = require("lspconfig")

local is_node_dir = function()
  return lspconfig.util.root_pattern("package.json")(vim.fn.getcwd())
end

require("mason-lspconfig").setup_handlers({
  function(server)
    local node_root_dir = lspconfig.util.root_pattern("package.json", "node_modules")

    local opts = {
      on_init = lsp.on_init,
      on_attach = lsp.on_attach_with_enable_format,
    }

    -- denols と tsserver を出し分ける
    if server == "denols" then
      if is_node_dir() then
        return
      end

      opts.cmd = { "deno", "lsp" }
      opts.init_options = { lint = true, unstable = true }
      opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
      opts.on_init = lsp.on_init_with_disable_format

      -- Node.js
    elseif server == "ts_ls" then
      if not is_node_dir() then
        return
      end

      local mason_registry = require("mason-registry")
      local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
        .. "/node_modules/@vue/language-server"

      opts.filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      }
      opts.init_options = {
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_language_server_path,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      }
      opts.root_dir = node_root_dir
      opts.on_init = lsp.on_init_with_disable_format

    -- css
    elseif server == "cssls" then
      opts.filetypes = { "css", "scss", "sass", "less" }

    -- efm
    elseif server == "efm" then
      opts = vim.tbl_deep_extend("force", opts, efm_opts())

    -- typos
    elseif server == "typos_lsp" then
      opts.init_options = {
        config = "~/.config/typos/.typos.toml",
        diagnosticSeverity = "Hint",
      }

    -- 内蔵フォーマッタを無効化
    elseif server == "html" or server == "jsonls" or server == "lua_ls" or server == "eslint" then
      opts.on_init = lsp.on_init_with_disable_format
      opts.on_attach = nil
    end

    lspconfig[server].setup(opts)
  end,
})

h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
h.nmap("]g", "<CMD>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })
h.nmap("[g", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic" })
h.nmap("gf", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Formatting" })
h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename definition" })
h.nmap("ga", "<CMD>Ddu lsp_codeAction -unique<CR>", { desc = "Show available code actions" })
h.nmap("gd", "<CMD>Ddu lsp_definition<CR>", { desc = "Lists all the definition" })
h.nmap("gr", "<CMD>Ddu lsp_references -unique<CR>", { desc = "Lists all the references" })
