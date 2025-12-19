require("nvim-treesitter").install({
  "astro",
  "bash",
  "c",
  "cpp",
  "css",
  "dart",
  "diff",
  "dockerfile",
  "git_config",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "graphql",
  "hcl",
  "html",
  "http",
  "ini",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "nginx",
  "php",
  "prisma",
  "python",
  "regex",
  "ruby",
  "rust",
  "scss",
  "sparql",
  "sql",
  "ssh_config",
  "svelte",
  "swift",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
})

-- ハイライト・インデントを有効化
-- ref: https://blog.atusy.net/2025/08/10/nvim-treesitter-main-branch/
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("nvim-treesitter-start", {}),
  callback = function(ctx)
    local buf = ctx.buf
    local max_filesize = 100 * 1024 -- 100 KB

    -- 大きなファイルでは無効化
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return
    end

    pcall(vim.treesitter.start, buf)

    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
