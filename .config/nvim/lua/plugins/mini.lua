local nmap = require("util.helper").nmap

return {
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    init = function()
      nmap("<Leader>gD", "<CMD>lua MiniDiff.toggle_overlay()<CR>", { desc = "Overlay git diff" })
    end,
    config = function()
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

      -- comment
      require("mini.comment").setup({})

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
            local searchcount = MiniStatusline.section_searchcount({ trunc_width = 75 })

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
              { hl = "MiniStatuslineFilename", strings = { get_lsp_progress(), searchcount } },
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl, strings = { "L%l" } },
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
              { hl = "MiniStatuslineFilename", strings = { filename() } },
            })
          end,
        },
        use_icons = true,
        set_vim_settings = false,
      })
    end,
  },
}
