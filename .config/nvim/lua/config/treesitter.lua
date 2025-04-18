require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local _ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if _ok and stats and stats.size > max_filesize then
				return true
			end
		end,
	},
	indent = { enable = true },
	ensure_installed = {
		"astro",
		"bash",
		"c",
		"comment",
		"cpp",
		"css",
		"dart",
		"dockerfile",
		"go",
		"gomod",
		"graphql",
		"html",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"make",
		"markdown",
		"php",
		"prisma",
		"python",
		"regex",
		"rust",
		"scss",
		"sparql",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},
})
