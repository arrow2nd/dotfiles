local dein_dir =  vim.env.HOME .. '/.cache/dein'
local dein_repo_dir = dein_dir .. '/repos/github.com/Shougo/dein.vim'

vim.opt.runtimepath:append(dein_repo_dir)

if vim.call('dein#load_state', dein_dir) == 1 then
  local toml_dir = vim.env.HOME .. '/.config/nvim/dein/toml'
  local toml = toml_dir .. '/dein.toml'
  local lazy_toml = toml_dir .. '/dein_lazy.toml'
  
  vim.api.nvim_set_var('dein#cache_directory', dein_dir)
  vim.call('dein#begin', dein_dir)
  vim.call('dein#add', dein_repo_dir)
  
  -- Load Plugins
  vim.call('dein#load_toml', toml, { lazy =  0 })
  vim.call('dein#load_toml', lazy_toml, { lazy = 1 })

  vim.call('dein#end')
  vim.call('dein#save_state')
end

vim.api.nvim_command('filetype plugin indent on')
vim.api.nvim_command('syntax enable')

-- If you want to install not installed plugins on startup.
if vim.call('dein#check_install') ~= 0 then
  vim.call('dein#install')
end
