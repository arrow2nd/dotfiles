local h = require("util.helper")
local fzf = require("fzf-lua")
local actions = fzf.actions

-- fzf の端末へ生のキーシーケンスを送る
-- vim.keycode() は Neovim 内部表現（K_SPECIAL）を返し fzf には解釈できないため、
-- 矢印・Alt はエスケープシーケンスをそのまま書く。
local function to_fzf(bufnr, seq)
  return function()
    vim.api.nvim_chan_send(vim.bo[bufnr].channel, seq)
  end
end

-- ノーマルモードのキー → fzf に送るキー
local normal_keys = {
  ["j"] = "\27[B", -- down
  ["k"] = "\27[A", -- up
  ["gg"] = "\27g", -- alt-g: first
  ["G"] = "\27G", -- alt-G: last
  ["<C-d>"] = "\6", -- ctrl-f: half-page-down
  ["<C-u>"] = "\2", -- ctrl-b: half-page-up
  ["<CR>"] = "\r", -- 開く
  ["<Tab>"] = "\t", -- 選択トグル
  ["<S-Tab>"] = "\27[Z",
  ["<C-s>"] = "\19", -- split
  ["<C-v>"] = "\22", -- vsplit
  ["<C-t>"] = "\20", -- tabedit
  ["<C-q>"] = "\17", -- quickfix へ送る
  ["q"] = "\27", -- esc: 閉じる
  ["<Esc>"] = "\27",
  -- git_status 用
  ["s"] = "\27[D", -- left: stage
  ["u"] = "\27[C", -- right: unstage
  ["X"] = "\24", -- ctrl-x: discard
}

fzf.setup({
  winopts = {
    split = "botright 15new",
    preview = { layout = "horizontal", horizontal = "right:50%" },
    on_create = function(e)
      local function map(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = e.bufnr, nowait = true, silent = true })
      end

      -- ターミナルモードの <Esc> は fzf を閉じず、ノーマルモードへ戻すだけにする
      map("t", "<Esc>", "<C-\\><C-n>")

      for lhs, seq in pairs(normal_keys) do
        map("n", lhs, to_fzf(e.bufnr, seq))
      end

      for _, lhs in ipairs({ "i", "a", "/" }) do
        map("n", lhs, "<CMD>startinsert<CR>")
      end

      -- fzf-lua は生成直後に startinsert するので、最初にターミナルモードへ入った時点で
      -- ノーマルモードに戻し、起動時はノーマルモードから始める
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "*:t",
        once = true,
        callback = function()
          if vim.api.nvim_get_current_buf() == e.bufnr then
            vim.schedule(function()
              vim.cmd("stopinsert")
            end)
          end
        end,
      })
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
