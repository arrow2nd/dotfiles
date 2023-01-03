local ok, lualine = pcall(require, 'lualine')
if (not ok) then return end

local function get_lsp_progress()
  local prog = vim.lsp.util.get_progress_messages()[1]
  if not prog then return '' end

  local title = prog.title or ""
  local per = prog.percentage or 0

  return string.format('%s (%s%%%%)', title, per)
end

lualine.setup {
}
