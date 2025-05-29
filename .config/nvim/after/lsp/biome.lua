local augroup = vim.api.nvim_create_augroup("BiomeLspFormatting", {})

local included_filetypes = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "astro",
}

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

        local filetype = vim.bo[bufnr].filetype
        local do_organize_imports = vim.tbl_contains(included_filetypes, filetype)

        if not do_organize_imports then
          return
        end

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
