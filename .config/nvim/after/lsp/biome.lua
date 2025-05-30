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

-- @see https://zenn.dev/izumin/articles/b8046e64eaa2b5
local function code_action_sync(client, bufnr, cmd)
  local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
  params.context = { only = { cmd }, diagnostics = {} }
  local res = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
  if res and res.result then
    for _, r in pairs(res.result) do
      if r.edit then
        vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
      end
    end
  end
end

return {
  on_attach = function(client, bufnr)
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

        code_action_sync(client, bufnr, "source.fixAll")

        local filetype = vim.bo[bufnr].filetype
        local do_organize_imports = vim.tbl_contains(included_filetypes, filetype)

        if do_organize_imports then
          code_action_sync(client, bufnr, "source.organizeImports")
        end
      end,
      group = augroup,
      buffer = bufnr,
    })
  end,
}
