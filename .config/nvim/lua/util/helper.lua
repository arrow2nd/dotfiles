local helper = {}

-- keymap
-- ref: https://github.com/skanehira/dotfiles/blob/master/vim/init.lua
for _, mode in pairs({ "n", "v", "i", "s", "o", "c", "t", "x" }) do
  helper[mode .. "map"] = function(lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, opts or { silent = true })
  end
end

return helper
