local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if (not lspconfig_ok) then return end

local mason_ok, mason = pcall(require, 'mason')
if (not mason_ok) then return end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if (not mason_lspconfig_ok) then return end

local cmp_ok, cmp = pcall(require, 'cmp')
if (not cmp_ok) then return end

local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if (not cmp_nvim_lsp_ok) then return end

local null_ls_ok, null_ls = pcall(require, 'null-ls')
if (not null_ls_ok) then return end

local h = require('helper')

-- mason.nvim
mason.setup({
  ui = {
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗'
    }
  }
})

-- mason-lspconfig.nvim
local common_on_attach = function(client, bufnr)
  -- キーマップ
  h.nmap('K', '<CMD>lua vim.lsp.buf.hover()<CR>')
  h.nmap('gf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  h.nmap('gr', '<CMD>lua vim.lsp.buf.references()<CR>')
  h.nmap('gd', '<CMD>lua vim.lsp.buf.definition()<CR>')
  h.nmap('gD', '<CMD>lua vim.lsp.buf.declaration()<CR>')
  h.nmap('gi', '<CMD>lua vim.lsp.buf.implementation()<CR>')
  h.nmap('gt', '<CMD>lua vim.lsp.buf.type_definition()<CR>')
  h.nmap('gn', '<CMD>lua vim.lsp.buf.rename()<CR>')
  h.nmap('ga', '<CMD>lua vim.lsp.buf.code_action()<CR>')
  h.nmap('ge', '<CMD>lua vim.diagnostic.open_float()<CR>')
  h.nmap('g]', '<CMD>lua vim.diagnostic.goto_next()<CR>')
  h.nmap('g[', '<CMD>lua vim.diagnostic.goto_prev()<CR>')

  -- 保存時に自動でフォーマット
  -- ref: https://github.com/skanehira/dotfiles/blob/master/vim/init.lua
  local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.formatting()
      end,
      group = augroup,
      buffer = bufnr,
    })
  end
end

local commom_capabilities = cmp_nvim_lsp.update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

mason_lspconfig.setup({
  ensure_installed = {
    'denols',
    'gopls',
    'tsserver',
    'sumneko_lua',
    'eslint',
    'yamlls',
    'jsonls',
    'python-lsp-server',
    'rust-analyzer',
    'tailwindcss-language-server',
  },
  automatic_installation = true,
})

mason_lspconfig.setup_handlers({ function(server)
  local node_root_dir = lspconfig.util.root_pattern('package.json')
  local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil

  local opts = {
    on_attach = common_on_attach,
    capabilities = commom_capabilities,
  }

  -- denols と tsserver を出し分ける
  -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
  if server == 'denols' then
    if is_node_repo then return end

    opts.cmd = { 'deno', 'lsp', '--unstable' }
    opts.root_dir = lspconfig.util.root_pattern('deps.ts', 'deno.json', 'import_map.json')
    opts.init_options = {
      lint = true,
      unstable = true
    }
  elseif server == 'tsserver' then
    opts.root_dir = node_root_dir
    opts.on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      common_on_attach(client, bufnr)
    end
  end

  lspconfig[server].setup(opts)
end })

-- null-ls.nvim
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with {
      prefer_local = 'node_modules/.bin',
      condition = function(utils)
        local type = vim.bo.filetype
        return type == 'markdown' or type == 'html' or type == 'css' or type == 'scss' or
            utils.has_file({ '.prettierrc', '.prettierrc.js' })
      end,
    },
  },
  on_attach = common_on_attach,
  capabilities = commom_capabilities,
})

-- lsp
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
)

-- 補完
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm { select = true },
  }),
  experimental = {
    ghost_text = true,
  },
})