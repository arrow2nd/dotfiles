local h = require("util.helper")

h.nmap("<CR>", "<CMD>lua require('kulala').run()<CR>", {
  noremap = true,
  silent = true,
  desc = "Execute the request",
})

h.nmap("<Leader>i", "<CMD>lua require('kulala').inspect()<CR>", {
  noremap = true,
  silent = true,
  desc = "Inspect the current request",
})

h.nmap("<Leader>t", "<CMD>lua require('kulala').toggle_view()<CR>", {
  noremap = true,
  silent = true,
  desc = "Toggle between body and headers",
})

h.nmap("<Leader>co", "<CMD>lua require('kulala').copy()<CR>", {
  noremap = true,
  silent = true,
  desc = "Copy the current request as a curl command",
})
