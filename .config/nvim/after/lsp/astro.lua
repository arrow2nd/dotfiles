local lsp = require("util.lsp")

local mason_tsdk = vim.fn.stdpath("data") .. "/mason/packages/astro-language-server/node_modules/typescript/lib"

-- lspconfig の tsdk 解決は node_modules/typescript しか見ないため、
-- typescript を直接依存に持たない pnpm プロジェクトでは解決できず astro-ls の initialize が失敗する
local function resolve_tsdk(root_dir)
  if not root_dir then
    return mason_tsdk
  end

  local tsdk = require("lspconfig.util").get_typescript_server_path(root_dir)
  if tsdk ~= "" then
    return tsdk
  end

  -- pnpm は直接依存以外をトップレベルに展開しないので仮想ストアから探す
  local from_pnpm = vim.fn.glob(root_dir .. "/node_modules/.pnpm/typescript@*/node_modules/typescript/lib", false, true)
  if #from_pnpm > 0 then
    return from_pnpm[1]
  end

  -- 見つからなくても astro-ls 自体は起動させたいので mason 同梱のものを使う
  return mason_tsdk
end

return {
  init_options = {
    typescript = {},
  },
  before_init = function(_, config)
    config.init_options.typescript.tsdk = resolve_tsdk(config.root_dir)
  end,
  on_init = lsp.on_init_with_disable_format,
  on_attach = nil,
}
