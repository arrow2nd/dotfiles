local h = require("util.helper")
local fzf = require("fzf-lua")
local actions = fzf.actions

fzf.setup({
  winopts = {
    split = "botright 15new",
    preview = { layout = "horizontal", horizontal = "right:50%" },
    on_create = function(win)
      -- ノーマルモードでも端末のカーソルではなくfzfの選択候補を操作する
      for key, input in pairs({ j = "\027[B", k = "\027[A", ["<CR>"] = "\r" }) do
        vim.keymap.set("n", key, function()
          vim.fn.chansend(vim.bo[win.bufnr].channel, input)
        end, { buffer = win.bufnr, nowait = true })
      end
    end,
  },
  previewers = { builtin = { treesitter = { enabled = false } } },
  file_ignore_patterns = { "^%.git/" },
  files = { hidden = true },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git' -e",
  },
  fzf_opts = { ["--history"] = vim.fn.stdpath("state") .. "/fzf-history" },
  keymap = {
    fzf = {
      true,
      ["ctrl-j"] = "down",
      ["ctrl-k"] = "up",
      ["ctrl-n"] = "next-history",
      ["ctrl-p"] = "prev-history",
    },
  },
  actions = {
    files = {
      true,
      ["ctrl-q"] = {
        fn = actions.file_sel_to_qf,
        -- 未選択なら全件を送り、Telescopeのsmart_send_to_qflistと同じイメージ
        prefix = [[transform(if [ "$FZF_SELECT_COUNT" -eq 0 ]; then printf select-all; fi)]],
      },
    },
  },
  git = {
    status = {
      actions = {
        ["left"] = { fn = actions.git_stage, reload = true },
        ["right"] = { fn = actions.git_unstage, reload = true },
        ["ctrl-x"] = { fn = actions.git_reset, reload = true, desc = "Discard to HEAD (including staged)" },
      },
    },
  },
})

fzf.register_ui_select({
  winopts = { split = false, width = 0.5, height = 0.25, backdrop = 100 },
  previewer = false,
})

h.nmap(";f", fzf.files)
h.nmap(";g", fzf.live_grep)
h.nmap(";h", fzf.helptags)
h.nmap(";o", function()
  fzf.oldfiles({ cwd_only = true })
end)
h.nmap(";O", fzf.oldfiles)
h.nmap(";B", "<CMD>GitWt<CR>")
h.nmap("<Leader>gg", fzf.git_status)
h.nmap("<Leader>gl", fzf.git_bcommits)
h.nmap("<Leader>gL", fzf.git_commits)
h.nmap("gE", fzf.diagnostics_workspace)
h.nmap("gr", fzf.lsp_references)
h.nmap("gi", fzf.lsp_implementations)
h.nmap("gd", fzf.lsp_definitions)
h.nmap("gt", fzf.lsp_typedefs)
h.nmap("ga", vim.lsp.buf.code_action)
