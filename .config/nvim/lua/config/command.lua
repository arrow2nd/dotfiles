local create_cmd = vim.api.nvim_create_user_command

-- 自動フォーマットを無視して保存
create_cmd("W", "noautocmd w", {})

-- TODO,FIXME 一括検索
create_cmd("Todo", "Ddu -name=grep -input=TODO:", {})
create_cmd("Fixme", "Ddu -name=grep -input=FIXME:", {})
