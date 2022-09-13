local helper = require('helper')

vim.api.nvim_set_var('gin_status_default_args', { '++opener=split' })
vim.api.nvim_set_var('gin_diff_default_args', { '++opener=vsplit' })
vim.api.nvim_set_var('gin_patch_default_args', { '++opener=vsplit' })

helper.nmap('<Leader>gs', '<CMD>GinStatus<CR>')
helper.nmap('<Leader>gl', '<CMD>GinBuffer ++opener=split log<CR>')
helper.nmap('<Leader>gd', '<CMD>GinDiff<CR>')

helper.nmap('<Leader>gc', '<CMD>Gin commit -v<CR>')
helper.nmap('<Leader>gp', '<CMD>GinPatch<CR>')

