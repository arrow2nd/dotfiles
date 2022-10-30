local fn = vim.fn

local token = fn.readfile(fn.expand('~/.config/denops-gitter/.token'))
vim.g['gitter#token'] = fn.trim(table.concat(token))
