-- 選択範囲の直下にコメント欄を開き、GitHub のレビューコメントのように
-- 現在のタブのまま Sidekick のセッションへ質問を送る
local M = {}

local ns = vim.api.nvim_create_namespace("sidekick_review")

--- バッファ名から LLM に渡す場所の表記を作る
---@param buf integer
---@return string
local function describe(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local ok, vf = pcall(require, "codediff.core.virtual_file")
  if ok then
    local root, rev, path = vf.parse_url(name)
    if root and rev and path then
      return ("%s (revision %s)"):format(path, rev)
    end
  end
  if name == "" then
    return "[No Name]"
  end
  return vim.fs.relpath(vim.fn.getcwd(), name) or name
end

---@param msg string
local function send(msg)
  local win = vim.api.nvim_get_current_win()
  require("sidekick.cli.state").with(function(state)
    state.session:send(msg)
    state.session:submit()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_set_current_win(win)
    end
  end, { attach = true, show = false, focus = false })
end

--- 選択範囲（ノーマルモードではカーソル行）に対するコメント欄を開く
function M.open()
  local buf = vim.api.nvim_get_current_buf()
  local src_win = vim.api.nvim_get_current_win()

  local s, e
  local mode = vim.fn.mode()
  if mode:match("^[vV\22]") then
    s, e = vim.fn.line("v"), vim.fn.line(".")
    if s > e then
      s, e = e, s
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    s = vim.fn.line(".")
    e = s
  end

  local code = vim.api.nvim_buf_get_lines(buf, s - 1, e, false)
  local range = s == e and ("L%d"):format(s) or ("L%d-%d"):format(s, e)
  local location = ("%s:%s"):format(describe(buf), range)

  -- コメント対象の行をハイライト
  vim.hl.range(buf, ns, "Visual", { s - 1, 0 }, { e - 1, -1 }, { regtype = "V" })

  local input = vim.api.nvim_create_buf(false, true)
  vim.bo[input].filetype = "markdown"
  vim.bo[input].bufhidden = "wipe"

  local width = math.max(math.min(vim.api.nvim_win_get_width(src_win) - 4, 100), 30)
  local comment_win = vim.api.nvim_open_win(input, true, {
    relative = "win",
    win = src_win,
    bufpos = { e - 1, 0 },
    row = 1,
    col = 0,
    width = width,
    height = 5,
    border = "single",
    title = " " .. location .. " ",
    footer = " <C-s>/<CR>: send  q: cancel ",
    footer_pos = "right",
  })

  local function close()
    vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
    if vim.api.nvim_win_is_valid(comment_win) then
      vim.api.nvim_win_close(comment_win, true)
    end
    if vim.api.nvim_win_is_valid(src_win) then
      vim.api.nvim_set_current_win(src_win)
    end
  end

  local function submit()
    local question = vim.trim(table.concat(vim.api.nvim_buf_get_lines(input, 0, -1, false), "\n"))
    if question == "" then
      vim.notify("Comment is empty", vim.log.levels.WARN)
      return
    end
    vim.cmd.stopinsert()
    close()

    local ft = vim.bo[buf].filetype
    local msg = table.concat({
      location,
      "```" .. ft,
      table.concat(code, "\n"),
      "```",
      "",
      question,
    }, "\n")
    send(msg)
  end

  local opts = { buffer = input, nowait = true, silent = true }
  vim.keymap.set({ "n", "i" }, "<C-s>", submit, opts)
  vim.keymap.set("n", "<CR>", submit, opts)
  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
  vim.api.nvim_create_autocmd("WinLeave", {
    buffer = input,
    once = true,
    callback = function()
      vim.schedule(close)
    end,
  })

  vim.cmd.startinsert()
end

return M
