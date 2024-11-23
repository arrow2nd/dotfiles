local h = require("util.helper")

vim.fn["ddc#custom#load_config"](vim.fn.expand("~/.config/nvim/ts/ddc.ts"))
vim.fn["ddc#enable"]({ context_filetype = "treesitter" })

for _, mode in pairs({ "n", "i", "x" }) do
	h[mode .. "map"](":", "<Cmd>call ddc#enable_cmdline_completion()<CR>:", { noremap = true })
	h[mode .. "map"]("/", "<Cmd>call ddc#enable_cmdline_completion()<CR>/", { noremap = true })
	h[mode .. "map"]("?", "<Cmd>call ddc#enable_cmdline_completion()<CR>?", { noremap = true })
end
