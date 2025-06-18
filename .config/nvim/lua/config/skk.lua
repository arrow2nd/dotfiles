local h = require("util.helper")

h.imap("<C-j>", "<Plug>(skkeleton-enable)")
h.cmap("<C-j>", "<Plug>(skkeleton-enable)")
h.tmap("<C-j>", "<Plug>(skkeleton-enable)")

-- 辞書を探す
local dictionaries = {}
local emoji_dict = nil
local handle = io.popen("ls $HOME/.skk/*") -- フルバスで取得
if handle then
  for file in handle:lines() do
    if file:match("skk%-jisyo%-emoji%-ja%.utf8$") then
      emoji_dict = file
    else
      table.insert(dictionaries, file)
    end
  end
  handle:close()
end

-- 絵文字辞書を最後に追加
if emoji_dict then
  table.insert(dictionaries, emoji_dict)
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
