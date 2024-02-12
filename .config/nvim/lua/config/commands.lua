-- 自動フォーマットを無視して保存
vim.api.nvim_create_user_command("W", "noautocmd w", {})
