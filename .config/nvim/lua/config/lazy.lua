local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(path) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    path,
  })
  if vim.v.shell_error ~= 0 then
    error("lazy.nvim の取得に失敗しました: " .. output)
  end
end
vim.opt.runtimepath:prepend(path)

require("lazy").setup(require("config.plugins"), {
  rocks = { enabled = false },
})
