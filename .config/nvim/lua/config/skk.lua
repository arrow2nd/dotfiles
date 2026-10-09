local h = require("util.helper")

h.imap("<C-j>", "<Plug>(skkelua-enable)")
h.cmap("<C-j>", "<Plug>(skkelua-enable)")
h.tmap("<C-j>", "<Plug>(skkelua-enable)")

-- 辞書を探す
local dictionaries = {}
local emoji_dict = nil
for _, file in ipairs(vim.fn.glob("~/.skk/*", false, true)) do
  if file:match("skk%-jisyo%-emoji%-ja%.utf8$") then
    emoji_dict = file
  else
    table.insert(dictionaries, file)
  end
end

-- 絵文字辞書を最後に追加
if emoji_dict then
  table.insert(dictionaries, emoji_dict)
end

require("skkelua").config({
  eggLikeNewline = true,
  registerConvertResult = true,
  globalDictionaries = dictionaries,
  -- 既存の学習結果を引き継ぐため、skkeleton と同じ辞書を使う。
  userDictionary = vim.fn.expand("~/.skkeleton"),
  completion = { enabled = true },
  indicator = { enabled = false },
})
