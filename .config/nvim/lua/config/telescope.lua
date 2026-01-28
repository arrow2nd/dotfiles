local h = require("util.helper")
local telescope = require("telescope")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

-- git_statusで変更を破棄するアクション
local function git_discard_changes(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if not selection then
    return
  end

  local status = selection.status
  local path = selection.path

  -- Telescopeを閉じずに確認
  local choice = vim.fn.confirm("Discard changes to " .. path .. "?", "&Yes\n&No", 2)
  if choice ~= 1 then
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

  -- pickerをリフレッシュして一覧を更新
  local git_root = picker.cwd or vim.fn.getcwd()
  local finder = finders.new_oneshot_job({ "git", "status", "-s", "--", "." }, {
    entry_maker = make_entry.gen_from_git_status({ cwd = git_root }),
    cwd = git_root,
  })
  picker:refresh(finder, { reset_prompt = false })
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
h.nmap(";g", "<CMD>Telescope live_grep<CR>")
h.nmap(";G", "<CMD>Telescope kensaku<CR>")
h.nmap(";h", "<CMD>Telescope help_tags<CR>")
h.nmap(";o", "<CMD>Telescope oldfiles cwd_only=true<CR>")
h.nmap(";O", "<CMD>Telescope oldfiles<CR>")
h.nmap("<Leader>gg", "<CMD>Telescope git_status<CR>")
h.nmap("<Leader>gl", "<CMD>Telescope git_bcommits<CR>")
h.nmap("<Leader>gL", "<CMD>Telescope git_commits<CR>")

h.nmap("gE", "<CMD>Telescope diagnostics<CR>")
h.nmap("gr", "<CMD>Telescope lsp_references<CR>")
h.nmap("gi", "<CMD>Telescope lsp_implementations<CR>")
h.nmap("gd", "<CMD>Telescope lsp_definitions<CR>")
h.nmap("gt", "<CMD>Telescope lsp_type_definitions<CR>")
h.nmap("ga", vim.lsp.buf.code_action)
