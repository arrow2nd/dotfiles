local skk = require("skkelua")

require("blink.cmp").setup({
  -- SKK の候補確定・学習は組み込み補完が処理するため、二重に補完しない。
  enabled = function()
    return not skk.is_enabled()
  end,
  keymap = {
    preset = "none",
    ["<C-n>"] = { "select_next", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },
    ["<C-y>"] = { "accept", "fallback" },
    ["<C-e>"] = { "cancel", "fallback" },
  },
  snippets = { preset = "vsnip" },
  fuzzy = { implementation = "lua" },
  completion = {
    list = { selection = { preselect = true, auto_insert = false } },
    menu = { border = "single", max_height = 24 },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      window = { border = "single", max_width = 72 },
    },
    accept = { auto_brackets = { enabled = false } },
  },
  sources = {
    default = { "lsp", "snippets", "path", "buffer" },
    min_keyword_length = 1,
    providers = {
      lsp = { fallbacks = {} },
      path = { fallbacks = {} },
      buffer = {
        override = {
          enabled = function()
            return true
          end,
        },
        opts = {
          get_bufnrs = function()
            local buffers = { vim.api.nvim_get_current_buf() }
            local alternate = vim.fn.bufnr("#")
            if vim.api.nvim_buf_is_loaded(alternate) then
              table.insert(buffers, alternate)
            end
            return buffers
          end,
          max_async_buffer_size = 5000000,
          max_total_buffer_size = 10000000,
        },
      },
    },
  },
  cmdline = {
    keymap = { preset = "inherit" },
    sources = function()
      if skk.is_enabled() then
        return {}
      end
      return vim.fn.getcmdtype() == ":" and { "cmdline", "buffer" } or { "buffer" }
    end,
    completion = {
      menu = { auto_show = true },
      ghost_text = { enabled = false },
    },
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "skkelua-enable-pre",
  callback = function()
    require("blink.cmp").hide()
  end,
})
