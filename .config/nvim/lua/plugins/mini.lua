return {
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        pattern = "*",
        callback = function()
          -- comment
          require("mini.comment").setup({})
          -- splitjoin
          require("mini.splitjoin").setup({})
          -- autopair
          require("mini.pairs").setup({})
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
        end,
        once = true,
      })

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

      -- starter
      require("mini.starter").setup({
        autoopen = true,
      })

      -- statusline
      require("mini.statusline").setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 }) -- 常にShort表示
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

            local filename = function()
              if vim.bo.buftype == "terminal" then
                return "%t"
              else
                return "%f%m%r"
              end
            end

            local get_lsp_progress = function()
              local prog = vim.lsp.status()
              if prog == "" then
                return ""
              end

              return string.format("󰔟 %s", prog:gsub("%%", "%%%%"))
            end

            return MiniStatusline.combine_groups({
              { hl = mode_hl, strings = { mode } },
              { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
              "%<", -- Mark general truncate point
              { hl = "MiniStatuslineFilename", strings = { filename() } },
              "%=", -- End left alignment
              { hl = "MiniStatuslineFilename", strings = { get_lsp_progress() } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { "L%l" } },
            })
          end,
          inactive = nil,
        },
        use_icons = true,
        set_vim_settings = false,
      })

      -- iceberg
      -- local mini_statusline_colors = {
      --   MiniStatuslineModeNormal = { bg = "#818596", fg = "#17171b" },
      --   MiniStatuslineModeInsert = { bg = "#84a0c6", fg = "#161821" },
      --   MiniStatuslineModeVisual = { bg = "#b4be82", fg = "#161821" },
      --   MiniStatuslineModeReplace = { bg = "#e2a478", fg = "#161821" },
      --   MiniStatuslineModeCommand = { bg = "#818596", fg = "#17171b" },
      --   MiniStatuslineModeOther = { bg = "#0f1117", fg = "#3e445e" },
      --   MiniStatuslineDevinfo = { bg = "#2e313f", fg = "#6b7089" },
      --   MiniStatuslineFileinfo = { bg = "#2e313f", fg = "#6b7089" },
      --   MiniStatuslineInactive = { link = "StatusLineNC" },
      -- }
      --
      -- for group, conf in pairs(mini_statusline_colors) do
      --   vim.api.nvim_set_hl(0, group, conf)
      -- end
    end,
  },
}
