---@diagnostic disable: undefined-global
local h = require("util.helper")

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

-- git
require("mini.git").setup()

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

-- 編集中バッファの「変更前」を右ペインに表示する
-- 左（現在のバッファ）には手を加えず、右に reference text を並べるだけ
-- 内容は mini.diff が保持する reference text を再利用するため、
-- source 設定（デフォルト = git index）にそのまま追従する
local function open_ref_view()
  local buf = vim.api.nvim_get_current_buf()
  local data = MiniDiff.get_buf_data(buf)

  -- source が未反応だと ref_text は nil になりうる
  if not data or not data.ref_text then
    vim.notify("mini.diff: reference text がまだありません", vim.log.levels.WARN)
    return
  end

  local src_win = vim.api.nvim_get_current_win()
  local ft = vim.bo[buf].filetype
  local ref_lines = vim.split(data.ref_text, "\n")
  -- ref_text は末尾に改行が付くため、split で生じる余分な空行を落とす
  if ref_lines[#ref_lines] == "" then
    table.remove(ref_lines)
  end

  vim.cmd("rightbelow vnew") -- 右に新規ウィンドウ
  local ref_win = vim.api.nvim_get_current_win()
  local ref_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(ref_buf, 0, -1, false, ref_lines)

  -- 保存対象外のスクラッチ。閉じたら破棄して残骸を残さない
  vim.bo[ref_buf].buftype = "nofile"
  vim.bo[ref_buf].bufhidden = "wipe"
  vim.bo[ref_buf].swapfile = false
  vim.bo[ref_buf].modifiable = false
  -- 元バッファと同じ filetype にすると FileType イベントで vim.treesitter.start が走り、
  -- treesitter ハイライトが効く（treesitter.lua の autocmd に追従）
  vim.bo[ref_buf].filetype = ft
  -- 同名バッファ衝突時にエラーで止めない
  pcall(vim.api.nvim_buf_set_name, ref_buf, ("%s [ref]"):format(vim.api.nvim_buf_get_name(buf)))

  -- 変更前(ref)側に行を持つ hunk ＝ 変更/削除された行だけをハイライトする
  -- （追加行は変更前に存在しない＝ ref_count が 0 なので、右ペインには現れない）
  local ns = vim.api.nvim_create_namespace("MiniRefDiffHl")
  for _, hunk in ipairs(data.hunks or {}) do
    if hunk.ref_count > 0 then
      local hl = (hunk.type == "delete") and "DiffDelete" or "DiffChange"
      for l = hunk.ref_start, hunk.ref_start + hunk.ref_count - 1 do
        vim.api.nvim_buf_set_extmark(ref_buf, ns, l - 1, 0, { line_hl_group = hl })
      end
    end
  end

  -- 左右のスクロールを同期する。diff モードではないため、行数の異なる差分があると徐々にズレる
  vim.wo[src_win].scrollbind = true
  vim.wo[ref_win].scrollbind = true
  -- 右ペインを閉じた後、左ウィンドウに scrollbind が残らないよう解除する
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(ref_win),
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(src_win) then
        vim.wo[src_win].scrollbind = false
      end
    end,
  })

  vim.cmd("wincmd p") -- フォーカスを左へ戻す
  vim.cmd("syncbind") -- 左を基準に右の表示位置を揃える
end

h.nmap("<Leader>gd", open_ref_view)

-- files
require("mini.files").setup({
  options = {
    use_as_default_explorer = true,
  },
  windows = {
    preview = true,
    width_preview = 50,
  },
})

h.nmap(";b", function()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" or vim.fn.filereadable(path) == 0 then
    MiniFiles.open()
  else
    MiniFiles.open(path)
  end
end)

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
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

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
        mode = "✚ " -- 💉
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
