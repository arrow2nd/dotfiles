local h = require("util.helper")

require("copilot").setup({
  -- mise管理のNodeを使う（lsp.luaのPATH設定と揃える）
  copilot_node_command = vim.fn.expand("$HOME") .. "/.local/share/mise/installs/node/lts/bin/node",
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      -- <c-cr>はsidekick.luaで一括ハンドリングするためfalse
      accept = false,
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    ["*"] = true,
  },
})

-- サジェストの受け入れ（copilot.lua）
for _, mode in pairs({ "n", "i" }) do
  h[mode .. "map"]("<c-cr>", function()
    local suggestion = require("copilot.suggestion")
    if suggestion.is_visible() then
      suggestion.accept()
      return
    end

    return "<c-cr>"
  end, { expr = true, desc = "Apply Copilot Suggestion" })
end

