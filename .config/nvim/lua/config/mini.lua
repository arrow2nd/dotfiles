vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  pattern = "*",
  callback = function()
    -- ai
    require("mini.ai").setup({})
    -- splitjoin
    require("mini.splitjoin").setup({})
    -- autopair
    require("mini.pairs").setup({})
  end,
  once = true,
})

-- diff
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "*", delete = "-" },
    priority = 199,
  },
  mappings = {
    apply = "gh",
    reset = "gH",
    textobject = "gh",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },
})

-- surround
require("mini.surround").setup({
  mappings = {
    add = "sa",
    delete = "sd",
    find = "sf",
    find_left = "sF",
    highlight = "sh",
    replace = "sc",
    update_n_lines = "sn",
    suffix_last = "l",
    suffix_next = "n",
  },
})

-- VSCode Neovim なら以下のプラグインは不要なので早期リターン
if vim.g.vscode then
  return
end

-- git
require("mini.git").setup({})

-- ブランチ名のみ
local format_summary = function(data)
  local summary = vim.b[data.buf].minigit_summary
  vim.b[data.buf].minigit_summary_string = summary.head_name or ""
end

local au_opts = { pattern = "MiniGitUpdated", callback = format_summary }
vim.api.nvim_create_autocmd("User", au_opts)

-- hipatterns
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },

    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

-- indentscope
require("mini.indentscope").setup({ symbol = "┆" })

-- icons
require("mini.icons").setup({})

-- notify
require("mini.notify").setup()

-- starter
require("mini.starter").setup({
  autoopen = true,
  header = [[
            ／l、
          （ﾟ､ ｡ ７
            l  ~ヽ
            じしf_,)ノ
         ]],
  silent = true,
})

-- statusline
require("mini.statusline").setup({
  content = {
    active = function()
      local separator = "|"

      local mode, mode_hl = MiniStatusline.section_mode({
        trunc_width = 9999, -- 常にShortで表示
      })

      if mode == "N" then
        mode = "✝"
      end

      local diagnostics = MiniStatusline.section_diagnostics({
        trunc_width = 75,
      })

      local fileinfo = MiniStatusline.section_fileinfo({
        trunc_width = 9999,
      })

      local git = MiniStatusline.section_git({ trunc_width = 40 })
      if git ~= "" then
        git = git .. " " .. separator
      end

      local filename = function()
        if vim.bo.buftype == "terminal" then
          return "%t"
        else
          return "%f%m%r" -- フルパス
        end
      end

      return MiniStatusline.combine_groups({
        {
          hl = mode_hl,
          strings = { mode },
        },
        {
          hl = "MiniStatuslineFilename",
          strings = { git, diagnostics, filename() },
        },
        "%=", -- End left alignment
        {
          hl = "MiniStatuslineFilename",
          strings = { fileinfo, separator, "%l" },
        },
      })
    end,
    inactive = function()
      local filename = function()
        if vim.bo.buftype == "terminal" then
          return "%t"
        else
          return "%f%m%r"
        end
      end

      return MiniStatusline.combine_groups({
        "%=", -- End left alignment
        {
          hl = "MiniStatuslineFilename",
          strings = { filename() },
        },
      })
    end,
  },
  use_icons = true,
  set_vim_settings = false,
})
