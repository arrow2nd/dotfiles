-- local Path = require("plenary.path")
-- local avante_path = require("avante.path")

require("avante_lib").load()

require("render-markdown").setup({
  heading = {
    position = "inline",
    icons = { "󰼏  ", "󰎨  " },
  },
  code = {
    left_pad = 2,
    right_pad = 4,
    highlight = "RenderMarkdownCode",
    highlight_inline = "RenderMarkdownCodeInline",
  },
  sign = {
    enabled = false,
  },
  file_types = {
    "Avante",
  },
})

require("avante").setup({
  provider = "copilot",
  copilot = {
    model = "claude-3.7-sonnet",
  },
  window = {
    position = "right",
    wrap = true,
    width = 32,
    sidebar_header = {
      enabled = true,
      align = "center",
      rounded = false,
    },
    input = {
      prefix = "> ",
      height = 8,
    },
    edit = {
      border = "single",
      start_insert = false,
    },
    ask = {
      floating = false,
      start_insert = false,
      border = "single",
      focus_on_apply = "ours",
    },
  },
})

-- FIXME: 上書きできなくなってる
-- local cache_path = vim.fn.expand("~/.config/nvim/avanterules")
--
-- -- デフォルトプロンプトを上書きする
-- -- NOTE: @see https://github.com/yetone/avante.nvim/issues/874
-- avante_path.prompts.get = function()
--   local static_dir = Path:new(cache_path)
--
--   if not static_dir:exists() then
--     error("Static directory does not exist: " .. static_dir:absolute(), 2)
--   end
--
--   return static_dir:absolute()
-- end
