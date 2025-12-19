local h = require("util.helper")
local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-n>"] = "cycle_history_next",
        ["<C-p>"] = "cycle_history_prev",
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
      n = {
        ["q"] = "close",
      },
    },
    results_title = false,
    prompt_prefix = " ",
    initial_mode = "normal",
    preview = {
      treesitter = false,
    },
    file_ignore_patterns = {
      "^.git/",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
    },
  },
  pickers = {
    find_files = { hidden = true },
  },
})

-- extensions
telescope.load_extension("ui-select")
telescope.load_extension("kensaku")

-- keymaps
h.nmap(";f", "<CMD>Telescope find_files<CR>")
h.nmap(";g", "<CMD>Telescope kensaku<CR>")
h.nmap(";h", "<CMD>Telescope help_tags<CR>")
h.nmap(";o", "<CMD>Telescope oldfiles<CR>")
h.nmap("<Leader>gg", "<CMD>Telescope git_status<CR>")
h.nmap("<Leader>gl", "<CMD>Telescope git_bcommits<CR>")
h.nmap("<Leader>gL", "<CMD>Telescope git_commits<CR>")

h.nmap("gE", "<CMD>Telescope diagnostics<CR>")
h.nmap("gr", "<CMD>Telescope lsp_references<CR>")
h.nmap("gi", "<CMD>Telescope lsp_implementations<CR>")
h.nmap("gd", "<CMD>Telescope lsp_definitions<CR>")
h.nmap("gt", "<CMD>Telescope lsp_type_definitions<CR>")
