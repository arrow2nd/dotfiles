-- ファイルに1行追加
local function append_to_file(file, line)
  local f = io.open(file, "a")
  if f == nil then
    print("Error: Cannot open file for writing")
    return
  end

  f:write(line .. "\n")
  f:close()
end

-- カーソル下の単語をファイルに追加
function WriteWordToFile(file_path)
  local file = file_path

  if file_path:sub(1, 1) == "~" then
    file = vim.uv.os_homedir() .. file_path:sub(2)
  end

  local word = vim.fn.expand("<cword>")

  -- 単語を編集させる
  local input = vim.fn.input("Edit word: ", string.lower(word))
  vim.api.nvim_command("redraw")
  if input == "" then
    print("No word provided. Operation canceled.")
    return
  end

  append_to_file(file, input)

  print("Word '" .. input .. "' has been written to " .. file)
end

-- ローカル辞書に追加
vim.api.nvim_create_user_command("AddCspellLocalDic", "lua WriteWordToFile('~/.local/share/cspell/user.txt')", {})

-- dotfilesで管理している辞書に追加
vim.api.nvim_create_user_command("AddCspellDotfilesDic", "lua WriteWordToFile('~/.config/cspell/dic.txt')", {})

-- 自動フォーマットを無視して保存
vim.api.nvim_create_user_command("W", "noautocmd w", {})
