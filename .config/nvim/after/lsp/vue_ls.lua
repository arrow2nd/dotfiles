local lsp = require("util.lsp")

-- lspconfig の vue_ls は on_init で tsserver へのリクエスト転送ハンドラを登録している。
-- 単純に on_init を差し替えると .vue の TypeScript 機能が丸ごと動かなくなるため、元の実装を呼んでから上書きする
local function get_lspconfig_on_init()
  -- このファイル自身も同じパターンにマッチするため、after 配下を除外しないと再帰する
  for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/vue_ls.lua", true)) do
    if not path:find("/after/lsp/", 1, true) then
      return dofile(path).on_init
    end
  end

  return nil
end

local lspconfig_on_init = get_lspconfig_on_init()

return {
  on_init = function(client, result)
    if lspconfig_on_init then
      lspconfig_on_init(client, result)
    end

    lsp.on_init_with_disable_format(client, result)
  end,
  on_attach = nil,
}
