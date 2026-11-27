local translate = require("util.translate")

local function complete_lang(arg_lead)
  return vim.tbl_filter(function(lang)
    return vim.startswith(lang, arg_lead)
  end, translate.languages)
end

vim.api.nvim_create_user_command("Translate", function(opts)
  translate.replace(opts.args ~= "" and opts.args or "en")
end, { nargs = "?", range = true, complete = complete_lang, desc = "選択範囲を翻訳して置換 (既定: en)" })

vim.api.nvim_create_user_command("TranslatePopup", function(opts)
  translate.popup(opts.args ~= "" and opts.args or "ja")
end, { nargs = "?", range = true, complete = complete_lang, desc = "選択範囲を翻訳して表示 (既定: ja)" })

-- 翻訳中も選択範囲が見えるように、ビジュアルモードを抜けずに呼ぶ
vim.keymap.set("x", "<Leader>t", function()
  translate.replace("en")
end, { desc = "選択範囲を英訳して置換" })
vim.keymap.set("x", "<Leader>T", function()
  translate.popup("ja")
end, { desc = "選択範囲を和訳して表示" })
