local create_cmd = vim.api.nvim_create_user_command

-- 自動フォーマットを無視して保存
create_cmd("W", "noautocmd w", {})

-- TODO,FIXME 一括検索
create_cmd("Todo", "Ddu -name=grep -input=TODO:", {})
create_cmd("Fixme", "Ddu -name=grep -input=FIXME:", {})

-- テキストを特定のレジスタにヤンクして自動ペースト
create_cmd("X", function(opts)
  local register = "z"
  local text = opts.args

  if text and #text > 0 then
    vim.fn.setreg(register, text)

    -- カーソル位置にペースト
    local mode = vim.api.nvim_get_mode().mode
    if mode:find("t") then
      -- 一度ノーマルモードに戻る
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "n", true)

      -- スケジュールを使って確実にノーマルモードになった後で実行
      vim.schedule(function()
        -- レジスタからペースト
        vim.api.nvim_put(vim.fn.getreg(register, 1, true), "", false, true)
        -- 端末モードに戻る
        vim.cmd("startinsert")
      end)
    else
      print("This command only works in terminal mode.")
    end
  end
end, {
  nargs = "+",
})
