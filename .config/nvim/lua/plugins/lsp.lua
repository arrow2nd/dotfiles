local h = require('util.helper')

local common_on_attach = function(client, bufnr)
  -- NOTE: 色がいっぱいあるの好きじゃないので切ってる
  client.server_capabilities.semanticTokensProvider = nil

  local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })

  -- 保存時に自動でフォーマット
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 5000 })
      end,
      group = augroup,
      buffer = bufnr,
    })
  end
end

local disable_fmt_on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  common_on_attach(client, bufnr)
end

return {
  {
    'neovim/nvim-lspconfig',
    event = 'BufReadPre',
    config = function()
      local lspconfig = require('lspconfig')

      require('mason-lspconfig').setup_handlers({ function(server)
        local buf_full_filename = vim.api.nvim_buf_get_name(0)
        local opts = { on_attach = common_on_attach }

        local node_root_dir = lspconfig.util.root_pattern('package.json')
        local is_node_repo = node_root_dir(buf_full_filename) ~= nil

        -- denols と tsserver を出し分ける
        -- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
        if server == 'denols' then
          if is_node_repo then return end
          opts.cmd = { 'deno', 'lsp', '--unstable' }
          opts.root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc')
          opts.init_options = { lint = true, unstable = true }
        elseif server == 'tsserver' then
          if not is_node_repo then return end
          opts.root_dir = node_root_dir
          opts.on_attach = disable_fmt_on_attach
        elseif server == 'tailwindcss' then
          local tailwind_root_dir = lspconfig.util.root_pattern('tailwind.config.[jt]s', 'twind.config.[jt]s')
          if tailwind_root_dir(buf_full_filename) == nil then return end
        elseif server == 'jsonls' then
          opts.on_attach = disable_fmt_on_attach
        end

        lspconfig[server].setup(opts)
      end })

      -- keymaps
      h.nmap('K', '<CMD>lua vim.lsp.buf.hover()<CR>', { desc = 'Show hover' })
      h.nmap('gf', '<CMD>lua vim.lsp.buf.format({ async = true })<CR>', { desc = 'Formatting' })
      h.nmap('ga', '<CMD>lua vim.lsp.buf.code_action()<CR>', { desc = 'Show available code actions' })
      h.nmap('gn', '<CMD>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename definition' })
      h.nmap('gr', '<CMD>lua vim.lsp.buf.references()<CR>', { desc = 'Show references' })
      h.nmap('gd', '<CMD>lua vim.lsp.buf.definition()<CR>', { desc = 'Show definitions' })
      h.nmap('gD', '<CMD>lua vim.lsp.buf.declaration()<CR>', { desc = 'Show declarations' })
      h.nmap('gt', '<CMD>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Show type definitions' })
      h.nmap('ge', '<CMD>lua vim.diagnostic.open_float()<CR>', { desc = 'Show diagnostic' })
      h.nmap('gE', '<CMD>lua vim.diagnostics.setqflist()<CR>', { desc = 'Send references to quickfix' })
      h.nmap(']g', '<CMD>lua vim.diagnostic.goto_next()<CR>', { desc = "Go to next diagnostic" })
      h.nmap('[g', '<CMD>lua vim.diagnostic.goto_prev()<CR>', { desc = "Go to previous diagnostic" })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    config = {
      ensure_installed = {
        'denols',
        'gopls',
        'tsserver',
        'lua_ls',
        'eslint',
        'yamlls',
        'jsonls',
        'rust_analyzer',
        'tailwindcss',
        'cssls',
      },
      automatic_installation = true,
    }
  },
  {
    'williamboman/mason.nvim',
    config = {
      ui = {
        icons = {
          package_installed = '',
          package_pending = '↻',
          package_uninstalled = ''
        }
      }
    }
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'BufReadPre',
    config = function()
      local null_ls = require('null-ls')

      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.diagnostics.textlint.with({
            filetypes = { 'markdown' },
            prefer_local = 'node_modules/.bin',
            condition = function(utils)
              return utils.has_file({ '.textlintrc', '.textlintrc.yml', '.textlintrc.json' })
            end,
          }),
        },
        on_attach = common_on_attach,
        diagnostics_format = '#{m} (#{s}: #{c})',
      })
    end
  }
}
