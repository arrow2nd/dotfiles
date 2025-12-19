local create_cmd = vim.api.nvim_create_user_command

-- 自動フォーマットを無視して保存
create_cmd("W", "noautocmd w", {})
