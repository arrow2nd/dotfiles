local lsp = require("util.lsp")
local h = require("util.helper")

-- LTSのNodeを使うように
local home_dir = vim.fn.expand("$HOME")
local node_bin = "/.local/share/mise/installs/node/lts/bin"

vim.g.node_host_prog = home_dir .. node_bin .. "/node"
vim.cmd("let $PATH = '" .. home_dir .. node_bin .. ":' . $PATH")

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
  automatic_installation = true,
  ensure_installed = {
    "astro",
    "efm",
    "denols",
    "gopls",
    "ts_ls",
    "vue_ls",
    "lua_ls",
    "yamlls",
    "jsonls",
    "rust_analyzer",
    "cssls",
    "biome",
    "eslint",
    "typos_lsp",
    "stylelint_lsp",
    "copilot",
  },
})

vim.lsp.config("*", {
  on_init = lsp.on_init,
})

vim.lsp.inline_completion.enable()

-- キーマップ
h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
h.nmap("K", "<CMD>lua vim.lsp.buf.hover()<CR>", { desc = "Show diagnostic" })
h.nmap("]g", "<CMD>lua vim.diagnostic.jump({ count = 1 })<CR>", { desc = "Go to next diagnostic" })
h.nmap("[g", "<CMD>lua vim.diagnostic.jump({ count = -1 })<CR>", { desc = "Go to previous diagnostic" })
h.nmap("gf", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Formatting" })
h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename definition" })
h.nmap("ga", "<CMD>Ddu lsp_codeAction -unique<CR>", { desc = "Show available code actions" })
h.nmap("gd", "<CMD>Ddu lsp_definition<CR>", { desc = "Lists all the definition" })
h.nmap("gr", "<CMD>Ddu lsp_references -unique<CR>", { desc = "Lists all the references" })
