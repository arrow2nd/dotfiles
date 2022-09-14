local ok, null_ls = pcall(require, 'null-ls')
if (not ok) then return end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.deno_fmt.with {
      condition = function(utils)
        return not (utils.has_file { ".prettierrc", ".prettierrc.js", "deno.json", "deno.jsonc" })
      end,
    },
    null_ls.builtins.formatting.prettier.with {
      condition = function(utils)
        if vim.bo.filetype == "markdown" then
          return true
        else
          return utils.has_file { ".prettierrc", ".prettierrc.js" }
        end
      end,
      prefer_local = "node_modules/.bin",
    },
  },
})
