require("avante_lib").load()

require("avante").setup({
  provider = "copilot",
  providers = {
    copilot = {
      model = "claude-sonnet-4",
    },
  },
  hints = {
    enabled = false,
  },
  windows = {
    position = "right",
    wrap = true,
    width = 30,
    sidebar_header = {
      enabled = true,
      align = "left",
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
