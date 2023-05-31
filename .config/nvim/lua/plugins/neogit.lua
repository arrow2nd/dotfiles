local nmap = require("util.helper").nmap

return {
  {
    "TimUntersberger/neogit",
    cmd = { "Neogit" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    init = function()
      nmap("<Leader>gg", "<CMD>Neogit<CR>", { desc = "Open Neogit" })
      nmap("<Leader>gc", "<CMD>Neogit commit<CR>", { desc = "git commit" })
    end,
    config = function()
      require("neogit").setup({
        disable_signs = false,
        disable_hint = false,
        disable_context_highlighting = false,
        disable_commit_confirmation = false,
        disable_insert_on_commit = true,
        auto_refresh = true,
        sort_branches = "-committerdate",
        disable_builtin_notifications = false,
        use_magit_keybindings = false,
        kind = "tab",
        console_timeout = 2000,
        auto_show_console = true,
        remember_settings = true,
        use_per_project_settings = true,
        ignored_settings = {},
        commit_popup = { kind = "split" },
        preview_buffer = { kind = "split" },
        popup = { kind = "split" },
        signs = {
          section = { ">", "v" },
          item = { ">", "v" },
          hunk = { "", "" },
        },
        integrations = { diffview = true },
        sections = {
          untracked = { folded = false },
          unstaged = { folded = false },
          staged = { folded = false },
          stashes = { folded = true },
          unpulled = { folded = true },
          unmerged = { folded = false },
          recent = { folded = true },
        },
      })
    end,
  },
}
