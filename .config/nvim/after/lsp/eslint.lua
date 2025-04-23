return {
  -- @see https://github.com/kyoh86/dotfiles/blob/0fafb25ec68ea9027b5373fbf82f66ed5d3b5fd1/nvim/lsp/denols.lua#L27-L34
  root_dir = function(bufnr, callback)
    local found_dirs = vim.fs.find({
      "eslint.config.js",
      "eslint.config.cjs",
      "eslint.config.mjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.mjs",
      ".eslintrc.json",
      ".eslintrc.yml",
      ".eslintrc.yaml",
    }, {
      upward = true,
      path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
    })
    if #found_dirs > 0 then
      return callback(vim.fs.dirname(found_dirs[1]))
    end
  end,
}
