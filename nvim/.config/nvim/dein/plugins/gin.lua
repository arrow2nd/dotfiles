local helper = require('helper')

helper.nmap('<Leader>gs', '<CMD>GinStatus ++opener=split<CR>')
helper.nmap('<Leader>gl', '<CMD>GinBuffer ++opener=split log<CR>')
helper.nmap('<Leader>gd', '<CMD>GinDiff ++opener=vsplit<CR>')

helper.nmap('<Leader>gc', '<CMD>Gin commit -v<CR>')
helper.nmap('<Leader>gp', '<CMD>GinPatch ++opener=vsplit<CR>')

