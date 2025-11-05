local lsp = require("util.lsp")

return {
  filetypes = {
    "css",
    "scss",
    "sass",
    "less",
  },
  on_init = lsp.on_init_with_disable_format,
  on_attach = nil,
}
