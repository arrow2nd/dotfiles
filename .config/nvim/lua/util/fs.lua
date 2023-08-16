return {
  has_file = function(...)
    local patterns = vim.tbl_flatten({ ... })

    for _, name in ipairs(patterns) do
      local full_path = vim.uv.fs_realpath(name)

      if full_path and vim.uv.fs_stat(full_path) ~= nil then
        return true
      end
    end

    return false
  end,
}
