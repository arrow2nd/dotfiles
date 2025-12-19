local h = require("util.helper")
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- git_statusで変更を破棄するアクション
local function git_discard_changes(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if not selection then
    return
  end

  local status = selection.status
  local path = selection.path

  -- 先にpickerを閉じる
  actions.close(prompt_bufnr)

  vim.ui.select({ "Yes", "No" }, {
    prompt = "Discard changes to " .. path .. "?",
  }, function(choice)
    if choice ~= "Yes" then
      return
    end

    -- 未追跡ファイル（??）または追加済み新規ファイル（A）の場合は削除
    if status == "??" or status == "A " or status == " A" then
      vim.fn.delete(path)
      vim.notify("Deleted: " .. path, vim.log.levels.INFO)
    else
      -- 変更されたファイルは git checkout で戻す
      vim.fn.system({ "git", "checkout", "--", path })
      vim.notify("Restored: " .. path, vim.log.levels.INFO)
    end

    -- バッファを再読み込み
    vim.cmd("checktime")
  end)
end

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
    git_status = {
      mappings = {
        n = {
          ["X"] = git_discard_changes,
        },
      },
    },
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
h.nmap("ga", vim.lsp.buf.code_action)
