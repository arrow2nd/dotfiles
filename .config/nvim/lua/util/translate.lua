-- PLaMo 3 Translate を載せたローカルの llama-server で翻訳する
local M = {}

M.endpoint = "http://127.0.0.1:8013/completion"

-- PLaMo 3 Translate が対応している言語コード
M.languages = {
  "ja",
  "en",
  "zh-hans",
  "zh-hant",
  "ko",
  "ar",
  "az",
  "be",
  "bg",
  "bn",
  "ca",
  "ceb",
  "de",
  "es",
  "et",
  "eu",
  "fa",
  "fr",
  "gu",
  "he",
  "hi",
  "hr",
  "hu",
  "hy",
  "id",
  "it",
  "jv",
  "ka",
  "kk",
  "km",
  "lt",
  "lv",
  "ml",
  "mr",
  "ms",
  "my",
  "ne",
  "nl",
  "pa",
  "pl",
  "ru",
  "si",
  "sk",
  "sl",
  "sr",
  "sw",
  "ta",
  "te",
  "th",
  "tl",
  "ur",
  "uz",
  "vi",
}

---@param text string
---@param target string
---@return string
local function build_prompt(text, target)
  -- BOS は llama-server が付けるので含めない
  return "<|plamo:tag|>dataset<|plamo:msg|>translation"
    .. "<|plamo:tag|>input<|plamo:msg|>"
    .. text
    .. "<|plamo:tag|>output<|plamo:key|>lang<|plamo:val|>"
    .. target
    .. "<|plamo:msg|>"
end

---@param text string
---@param target string
---@param callback fun(result: string)
function M.request(text, target, callback)
  local body = vim.json.encode({
    prompt = build_prompt(text, target),
    temperature = 0,
    n_predict = 2048,
    stop = { "<|plamo:tag|>", "<|plamo:bos|>" },
  })

  vim.system(
    {
      "curl",
      "-sS",
      "--fail",
      "--max-time",
      "120",
      "-H",
      "Content-Type: application/json",
      "--data-binary",
      "@-",
      M.endpoint,
    },
    { stdin = body, text = true },
    vim.schedule_wrap(function(res)
      if res.code ~= 0 then
        vim.notify("翻訳に失敗しました: " .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
        return
      end
      local ok, decoded = pcall(vim.json.decode, res.stdout)
      if not ok or type(decoded.content) ~= "string" then
        vim.notify("翻訳結果を解釈できませんでした: " .. res.stdout, vim.log.levels.ERROR)
        return
      end
      callback((decoded.content:gsub("%s+$", "")))
    end)
  )
end

---@class translate.Region
---@field buf integer
---@field text string
---@field start_row integer 0-based
---@field start_col integer 0-based, byte
---@field end_row integer 0-based
---@field end_col integer 0-based, byte, exclusive

---@return boolean
local function in_visual_mode()
  return vim.fn.mode():find("^[vV\22]") ~= nil
end

---選択範囲を取得する
---@return translate.Region?
function M.get_visual_region()
  local buf = vim.api.nvim_get_current_buf()
  local mode, p1, p2
  if in_visual_mode() then
    mode, p1, p2 = vim.fn.mode(), vim.fn.getpos("v"), vim.fn.getpos(".")
  else
    mode, p1, p2 = vim.fn.visualmode(), vim.fn.getpos("'<"), vim.fn.getpos("'>")
  end
  if mode == "\22" then
    vim.notify("矩形選択には対応していません", vim.log.levels.WARN)
    return nil
  end

  local text = table.concat(vim.fn.getregion(p1, p2, { type = mode }), "\n")
  -- getregionpos は選択の向きによらず先頭から順に返す
  local regions = vim.fn.getregionpos(p1, p2, { type = mode })
  local start_row, end_row = regions[1][1][2] - 1, regions[#regions][2][2] - 1

  local start_col, end_col
  if mode == "V" then
    start_col = 0
    end_col = #vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, true)[1]
  else
    start_col = regions[1][1][3] - 1
    local last_line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, true)[1]
    -- `$` で行末まで選んだときは改行の位置を指すので行の長さに丸める
    end_col = math.min(regions[#regions][2][3], #last_line)
  end

  return {
    buf = buf,
    text = text,
    start_row = start_row,
    start_col = start_col,
    end_row = end_row,
    end_col = end_col,
  }
end

---選択範囲を翻訳して置き換える
---@param target string
function M.replace(target)
  local region = M.get_visual_region()
  if not region or region.text == "" then
    return
  end
  local tick = vim.api.nvim_buf_get_changedtick(region.buf)

  M.request(region.text, target, function(result)
    if not vim.api.nvim_buf_is_loaded(region.buf) or vim.api.nvim_buf_get_changedtick(region.buf) ~= tick then
      vim.notify("翻訳中にバッファが変更されたため、置換を中止しました", vim.log.levels.WARN)
      return
    end
    vim.api.nvim_buf_set_text(
      region.buf,
      region.start_row,
      region.start_col,
      region.end_row,
      region.end_col,
      vim.split(result, "\n", { plain = true })
    )
    if in_visual_mode() then
      vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    end
  end)
end

---選択範囲を翻訳してフローティングウィンドウに表示する
---@param target string
function M.popup(target)
  local region = M.get_visual_region()
  if not region or region.text == "" then
    return
  end

  M.request(region.text, target, function(result)
    -- 表示してから抜けるとモード変更でポップアップが閉じかねないので、先に抜ける
    if in_visual_mode() then
      vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    end
    vim.lsp.util.open_floating_preview(vim.split(result, "\n", { plain = true }), "", {
      border = "single",
      focus_id = "translate",
      max_width = math.floor(vim.o.columns * 0.6),
    })
  end)
end

return M
