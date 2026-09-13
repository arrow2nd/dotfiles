require("translate").setup({
  default = {
    command = "google",
    parse_before = "remember,trim,natural",
    output = "replace_original",
  },
  parse_before = {
    remember = {
      cmd = function(lines, pos)
        pos.buf = vim.api.nvim_get_current_buf()
        pos.tick = vim.api.nvim_buf_get_changedtick(pos.buf)
        return lines
      end,
    },
  },
  output = {
    replace_original = {
      cmd = function(lines, pos)
        -- 非同期の翻訳中に別バッファへ移動・編集しても、無関係な内容を上書きしない
        if not vim.api.nvim_buf_is_loaded(pos.buf) or vim.api.nvim_buf_get_changedtick(pos.buf) ~= pos.tick then
          vim.notify(
            "翻訳中にバッファが変更されたみたいなので、置換を中止しました",
            vim.log.levels.WARN
          )
          return
        end
        vim.api.nvim_buf_call(pos.buf, function()
          require("translate.preset.output.replace").cmd(lines, pos)
        end)
      end,
    },
  },
  preset = { command = { google = { args = { "--fail", "--max-time", "30" } } } },
})

vim.keymap.set("x", "<Leader>t", "<Cmd>Translate en -source=ja<CR>", { desc = "選択範囲を英訳して置換" })
