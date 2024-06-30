local h = require("util.helper")
local optl = vim.opt_local

-- ref: Vimでmarkdownの箇条書き（kawarimidoll）
--      https://zenn.dev/vim_jp/articles/4564e6e5c2866d

-- 引用符
optl.comments = "nb:>"

-- リスト（- / - [ ] / * / 1.）
optl.comments:append("b:- [ ],b:- [x],b:-")
optl.comments:append("b:*")
optl.comments:append("b:1.")

optl.formatoptions:remove("c")
optl.formatoptions:append("jro")

-- チェックボックス切替
local markdown_checkbox = function()
  local line = vim.api.nvim_get_current_line()
  local list_pattern = "\\v^\\s*([*+-]|\\d+\\.)\\s+"

  if not vim.regex(list_pattern):match_str(line) then
    -- not list -> nothing to do
    return
  elseif vim.regex(list_pattern .. "\\[ \\]\\s+"):match_str(line) then
    -- blank box -> check
    line, _ = line:gsub("%[ %]", "[x]", 1)
  elseif vim.regex(list_pattern .. "\\[x\\]\\s+"):match_str(line) then
    -- checked box -> uncheck
    line, _ = line:gsub("%[x%]", "[ ]", 1)
  end

  vim.api.nvim_set_current_line(line)
end

vim.api.nvim_buf_create_user_command(0, "MarkdownCheckbox", function()
  markdown_checkbox()
end, {})

h.nmap("<C-CR>", "<CMD>MarkdownCheckbox<CR>", { buffer = true, desc = "Toggle checkbox" })
