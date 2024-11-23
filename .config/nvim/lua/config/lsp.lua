local lsp = require("util.lsp")
local h = require("util.helper")

local efm_opts = function()
	local rootMarkers = {
		prettier = {
			".prettierrc",
			".prettierrc.js",
			".prettierrc.mjs",
			".prettierrc.cjs",
			".prettierrc.yml",
			".prettierrc.yaml",
			".prettierrc.json",
			".prettierrc.json5",
			".prettierrc.toml",
		},
		stylua = {
			"stylua.toml",
			".stylua.toml",
		},
		textlint = {
			".textlintrc",
			".textlintrc.yml",
			".textlintrc.yaml",
			".textlintrc.json",
		},
	}

	local prettier = {
		formatCommand = "node_modules/.bin/prettier --stdin --stdin-filepath ${INPUT}",
		formatStdin = true,
		rootMarkers = rootMarkers.prettier,
	}

	local denofmt = {
		formatCommand = "deno fmt --ext ${FILEEXT} -",
		formatStdin = true,
	}

	-- Prettier の設定がなければ denofmt を使う
	local lspconfig = require("lspconfig")
	local rootdir = lspconfig.util.root_pattern(rootMarkers.prettier)
	local buf_full_filename = vim.api.nvim_buf_get_name(0)
	local denofmt_or_prettier = rootdir(buf_full_filename) and prettier or denofmt

	local stylua = {
		formatCommand = "stylua --color Never -",
		formatStdin = true,
		rootMarkers = rootMarkers.stylua,
	}

	local textlint = {
		lintCommand = "node_modules/.bin/textlint --no-color --format compact --stdin --stdin-filename ${INPUT}",
		lintStdin = true,
		lintFormats = {
			"%.%#: line %l, col %c, %trror - %m",
			"%.%#: line %l, col %c, %tarning - %m",
		},
		rootMarkers = rootMarkers.textlint,
	}

	local languages = {
		html = { prettier },
		css = { prettier },
		scss = { prettier },
		javascript = { denofmt_or_prettier },
		javascriptreact = { denofmt_or_prettier },
		typescript = { denofmt_or_prettier },
		typescriptreact = { denofmt_or_prettier },
		json = { denofmt_or_prettier },
		jsonc = { denofmt_or_prettier },
		yaml = { prettier },
		markdown = { denofmt_or_prettier, textlint },
		lua = { stylua },
	}

	return {
		init_options = {
			documentFormatting = true,
			hover = true,
			codeAction = true,
		},
		filetypes = vim.tbl_keys(languages),
		settings = { languages = languages },
	}
end

-- ポップアップウィンドウのボーダースタイルを設定
vim.diagnostic.config({
	float = {
		border = "single",
	},
})

require("mason").setup({
	ui = {
		border = "single",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"astro",
		"efm",
		"denols",
		"gopls",
		"ts_ls",
		"lua_ls",
		"yamlls",
		"jsonls",
		"rust_analyzer",
		"cssls",
		"eslint",
		"biome",
		"typos_lsp",
	},
	automatic_installation = true,
})

--  client_capabilities と forceCompletionPattern を設定
require("ddc_source_lsp_setup").setup()

local lspconfig = require("lspconfig")

require("mason-lspconfig").setup_handlers({
	function(server)
		local buf_full_filename = vim.api.nvim_buf_get_name(0)

		local opts = {
			on_attach = lsp.enable_fmt_on_attach,
		}

		local node_root_dir = lspconfig.util.root_pattern("package.json")
		local is_node_dir = node_root_dir(buf_full_filename) ~= nil

		local deno_root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
		local is_deno_dir = deno_root_dir(buf_full_filename) ~= nil

		-- denols と tsserver を出し分ける
		-- ref: https://zenn.dev/kawarimidoll/articles/2b57745045b225
		if server == "denols" then
			if not is_deno_dir then
				return
			end
			opts.root_dir = deno_root_dir
			opts.cmd = { "deno", "lsp" }
			opts.init_options = { lint = true, unstable = true }
			opts.on_attach = lsp.disable_fmt_on_attach

		-- Node.js
		elseif server == "tsserver" then
			if is_deno_dir or not is_node_dir then
				return
			end
			opts.filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
			}
			opts.root_dir = node_root_dir
			opts.on_attach = lsp.disable_fmt_on_attach

		-- css
		elseif server == "cssls" then
			opts.filetypes = { "css", "scss", "sass", "less" }

		-- efm
		elseif server == "efm" then
			opts = vim.tbl_deep_extend("force", opts, efm_opts())

		-- typos
		elseif server == "typos_lsp" then
			opts.init_options = {
				config = "~/.config/typos/.typos.toml",
				diagnosticSeverity = "Hint",
			}

		-- 内蔵フォーマッタを無効化
		elseif server == "html" or server == "jsonls" or server == "lua_ls" then
			opts.on_attach = lsp.disable_fmt_on_attach
		end

		lspconfig[server].setup(opts)
	end,
})

h.nmap("ge", "<CMD>lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostic" })
h.nmap("]g", "<CMD>lua vim.diagnostic.goto_next()<CR>", { desc = "Go to next diagnostic" })
h.nmap("[g", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { desc = "Go to previous diagnostic" })
h.nmap("gf", "<CMD>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Formatting" })
h.nmap("gn", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename definition" })
h.nmap("ga", "<CMD>Ddu lsp_codeAction -unique<CR>", { desc = "Show available code actions" })
h.nmap("gd", "<CMD>Ddu lsp_definition<CR>", { desc = "Lists all the definition" })
h.nmap("gr", "<CMD>Ddu lsp_references -unique<CR>", { desc = "Lists all the references" })
