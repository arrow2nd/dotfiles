local augroup = vim.api.nvim_create_augroup("BiomeLspFormatting", {})

return {
  on_attach = function(_, bufnr)
    vim.api.nvim_clear_autocmds({
      group = augroup,
      buffer = bufnr,
    })

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
        -- フォーマット
        vim.lsp.buf.format({
          async = false,
          timeout_ms = 5000,
        })

        -- importのソート
        vim.lsp.buf.code_action({
          context = {
            only = { "source.organizeImports" },
          },
          apply = true,
        })
      end,
      group = augroup,
      buffer = bufnr,
    })
  end,
}
