local h = require("util.helper")

h.imap("<C-j>", "<Plug>(skkeleton-enable)")
h.cmap("<C-j>", "<Plug>(skkeleton-enable)")
h.tmap("<C-j>", "<Plug>(skkeleton-enable)")

-- 辞書を探す
local dictionaries = {}
local handle = io.popen("ls $HOME/.skk/*") -- フルバスで取得
if handle then
  for file in handle:lines() do
    table.insert(dictionaries, file)
  end
  handle:close()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "skkeleton-initialize-pre",
  callback = function()
    vim.fn["skkeleton#config"]({
      eggLikeNewline = true,
      registerConvertResult = true,
      globalDictionaries = dictionaries,
    })
  end,
})
