local h = require("util.helper")

require("aibo").setup({
  submit_delay = 500,
  submit_key = "<CR>",
  prompt_height = 10,
  prompt_blend_insert = 10,
  prompt_blend_normal = 30,
  termcode_mode = "hybrid",
  disable_startinsert_on_startup = false,
  disable_startinsert_on_insert = false,
})

-- フォーカス移動
for _, mode in pairs({ "n", "x", "i", "t" }) do
  h[mode .. "map"]("<c-.>", function()
    -- ターミナルバッファにいる場合は前のウィンドウに戻る
    if vim.bo.buftype == "terminal" then
      vim.cmd("wincmd p")
    else
      vim.cmd("Aibo -focus claude")
    end
  end, { desc = "Aibo Switch Focus" })
end

for _, mode in pairs({ "n", "v" }) do
  -- Claude Code
  h[mode .. "map"]("<leader>av", function()
    vim.cmd("Aibo -opener=vsplit -toggle claude")
  end, { desc = "Aibo Claude Toggle" })

  h[mode .. "map"]("<leader>as", function()
    vim.cmd("Aibo -opener=botright\\ split -toggle claude")
  end, { desc = "Aibo Claude Toggle" })

  -- プロンプト入力
  h[mode .. "map"]("<leader>ap", function()
    vim.cmd("AiboSend -input")
  end, { desc = "Aibo Prompt Input" })
end

-- 選択範囲の位置情報付きで入力欄に送る
h.vmap("<leader>ap", function()
  local filepath = vim.api.nvim_buf_get_name(0)

  if filepath == "" then
    vim.notify("No file associated with current buffer", vim.log.levels.WARN)
    return
  end

  -- コンソールが現在のタブページに無ければ vsplit で開く
  local console = require("aibo.internal.console_window")

  if not console.find_info_in_tabpage({ cmd = "claude" }) then
    vim.cmd("Aibo -opener=vsplit -stay claude")
  end

  -- 選択範囲の行・列番号を取得
  local s = vim.fn.line("v")
  local e = vim.fn.line(".")

  if s > e then
    s, e = e, s
  end

  require("aibo.command.aibo_send").call({
    line1 = 1,
    line2 = 0, -- 空レンジ → バッファ内容なし
    input = true,
    replace = true,
    prefix = "@" .. filepath .. ":" .. s .. "-" .. e .. " ",
  })
end, { desc = "Aibo Prompt Input with location" })
