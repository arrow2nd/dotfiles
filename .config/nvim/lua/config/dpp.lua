-- 参考:
-- https://looxu.blogspot.com/2024/11/dppvim.html
-- https://zenn.dev/comamoca/articles/howto-setup-dpp-vim
-- https://zenn.dev/block/articles/32a503f6f63149

local cache_path = vim.fn.stdpath("cache") .. "/dpp/repos/github.com"
local dpp_src_path = cache_path .. "/Shougo/dpp.vim"
local denops_src_path = cache_path .. "/vim-denops/denops.vim"

-- dppのパスをruntimepathに追加
vim.opt.runtimepath:prepend(dpp_src_path)

-- check repository exists.
local function ensure_repo_exists(repo_url, dest_path)
	if not vim.loop.fs_stat(dest_path) then
		vim.fn.system({ "git", "clone", "https://github.com/" .. repo_url .. ".git", dest_path })
	end
end

-- 最低限必要なプラグインをチェック、なれけばclone
ensure_repo_exists("vim-denops/denops.vim", denops_src_path)
ensure_repo_exists("Shougo/dpp.vim", dpp_src_path)

local dpp = require("dpp")

local dpp_base_dir = vim.fn.stdpath("cache") .. "/dpp"
local dpp_config_path = vim.fn.stdpath("config") .. "/ts/dpp.ts"

local extension_urls = {
	"Shougo/dpp-ext-installer",
	"Shougo/dpp-ext-toml",
	"Shougo/dpp-protocol-git",
	"Shougo/dpp-ext-lazy",
	-- "Shougo/dpp-ext-local",
}

-- dppのプラグインをruntimepathに追加
for _, url in ipairs(extension_urls) do
	local ext_path = cache_path .. "/" .. url
	ensure_repo_exists(url, ext_path)
	vim.opt.runtimepath:append(ext_path)
end

-- denopsの共有サーバーの設定
vim.g.denops_server_addr = "127.0.0.1:32123"

if dpp.load_state(dpp_base_dir) then
	-- denops
	vim.opt.runtimepath:prepend(denops_src_path)

	-- dpp
	local augroup = vim.api.nvim_create_augroup("ddp", {})

	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "DenopsReady",
		callback = function()
			vim.notify("vim load_state is failed")
			dpp.make_state(dpp_base_dir, dpp_config_path)
		end,
	})
end

vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function()
		vim.notify("dpp make_state() is done")
	end,
})

-- Install
vim.api.nvim_create_user_command("DppInstall", "call dpp#async_ext_action('installer', 'install')", {})

-- update
vim.api.nvim_create_user_command("DppUpdate", function(opts)
	local args = opts.fargs
	vim.fn["dpp#async_ext_action"]("installer", "update", { names = args })
end, { nargs = "*" })
