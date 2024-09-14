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

      -- git
      require("mini.git").setup({})

      -- ブランチ名のみ
      local format_summary = function(data)
        local summary = vim.b[data.buf].minigit_summary
        vim.b[data.buf].minigit_summary_string = summary.head_name or ""
      end

      local au_opts = { pattern = "MiniGitUpdated", callback = format_summary }
      vim.api.nvim_create_autocmd("User", au_opts)

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
        header = [[
              ／l、
            （ﾟ､ ｡ ７
              l  ~ヽ
              じしf_,)ノ
           ]],
      })

      -- statusline
      require("mini.statusline").setup({
        content = {
          active = function()
            local separator = "|"

            local mode, mode_hl = MiniStatusline.section_mode({
              trunc_width = 9999, -- 常にShortで表示
            })

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

            local get_lsp_progress = function()
              local prog = vim.lsp.status()
              if prog == "" then
                return ""
              end

              return string.format("󰔟 %s %s", prog:gsub("%%", "%%%%"), separator)
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
                strings = { get_lsp_progress(), fileinfo, separator, "%l" },
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
    end,
  },
}
