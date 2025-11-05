local lsp = require("util.lsp")

return {
  settings = {
    stylelintplus = {
      autoFixOnSave = true,
    },
  },
  on_attach = lsp.on_attach_with_enable_format,
}
