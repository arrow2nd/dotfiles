local vue_language_server_path = vim.fn.exepath("vue-language-server") .. "/node_modules/@vue/language-server"

return {
  -- @see https://github.com/kyoh86/dotfiles/blob/0fafb25ec68ea9027b5373fbf82f66ed5d3b5fd1/nvim/lsp/denols.lua#L27-L34
  root_dir = function(bufnr, callback)
    local found_dirs = vim.fs.find({
      "package.json",
    }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "javascript", "typescript", "vue" },
      },
    },
  },
  on_attach = nil,
}
