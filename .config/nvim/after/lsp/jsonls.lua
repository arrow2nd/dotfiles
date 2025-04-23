local lsp = require("util.lsp")

return {
  on_init = lsp.on_init_with_disable_format,
}
