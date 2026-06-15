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
local ref_view = { src_win = nil, ref_win = nil, ref_buf = nil, ns = nil, augroup = nil }

-- src ウィンドウの現在バッファに合わせて右ペインを再描画する（冪等）
-- 左でファイルを切り替えても ref_buf は使い回し、内容だけ差し替える
local function render_ref()
  if not (ref_view.src_win and vim.api.nvim_win_is_valid(ref_view.src_win)) then
    return
  end
  if not (ref_view.ref_buf and vim.api.nvim_buf_is_valid(ref_view.ref_buf)) then
    return
  end

  local src_buf = vim.api.nvim_win_get_buf(ref_view.src_win)
  local data = MiniDiff.get_buf_data(src_buf)
  local ft = vim.bo[src_buf].filetype

  -- ref_text が無い（git 管理外・source 未反応）場合は空表示にする
  local ref_lines = {}
  if data and data.ref_text then
    ref_lines = vim.split(data.ref_text, "\n")
    -- ref_text は末尾に改行が付くため、split で生じる余分な空行を落とす
    if ref_lines[#ref_lines] == "" then
      table.remove(ref_lines)
    end
  end

  local ref_buf = ref_view.ref_buf
  vim.bo[ref_buf].modifiable = true
  vim.api.nvim_buf_set_lines(ref_buf, 0, -1, false, ref_lines)
  vim.bo[ref_buf].modifiable = false
  -- 元バッファと同じ filetype にすると FileType イベントで vim.treesitter.start が走り、
  -- treesitter ハイライトが効く（treesitter.lua の autocmd に追従）
  vim.bo[ref_buf].filetype = ft
  -- 同名バッファ衝突時にエラーで止めない
  pcall(vim.api.nvim_buf_set_name, ref_buf, ("%s [ref]"):format(vim.api.nvim_buf_get_name(src_buf)))

  -- 変更前(ref)側に行を持つ hunk ＝ 変更/削除された行だけをハイライトする
  -- （追加行は変更前に存在しない＝ ref_count が 0 なので、右ペインには現れない）
  vim.api.nvim_buf_clear_namespace(ref_buf, ref_view.ns, 0, -1)
  for _, hunk in ipairs((data and data.hunks) or {}) do
    if hunk.ref_count > 0 then
      local hl = (hunk.type == "delete") and "DiffDelete" or "DiffChange"
      for l = hunk.ref_start, hunk.ref_start + hunk.ref_count - 1 do
        vim.api.nvim_buf_set_extmark(ref_buf, ref_view.ns, l - 1, 0, { line_hl_group = hl })
      end
    end
  end

  -- 左右のスクロールを同期する。diff モードではないため、行数の異なる差分があると徐々にズレる
  vim.wo[ref_view.src_win].scrollbind = true
  if ref_view.ref_win and vim.api.nvim_win_is_valid(ref_view.ref_win) then
    vim.wo[ref_view.ref_win].scrollbind = true
  end
  -- イベント発火時のカレントウィンドウに依存せず、左を基準に右の表示位置を揃える
  vim.api.nvim_win_call(ref_view.src_win, function()
    vim.cmd("syncbind")
  end)
end

-- 右ペインを閉じて状態を片付ける
local function close_ref_view()
  if ref_view.augroup then
    pcall(vim.api.nvim_del_augroup_by_id, ref_view.augroup)
  end
  -- 右ペインを閉じた後、左ウィンドウに scrollbind が残らないよう解除する
  if ref_view.src_win and vim.api.nvim_win_is_valid(ref_view.src_win) then
    vim.wo[ref_view.src_win].scrollbind = false
  end
  if ref_view.ref_win and vim.api.nvim_win_is_valid(ref_view.ref_win) then
    -- ref_buf は bufhidden = "wipe" なのでウィンドウを閉じれば自動で破棄される
    pcall(vim.api.nvim_win_close, ref_view.ref_win, true)
  end
  ref_view.src_win = nil
  ref_view.ref_win = nil
  ref_view.ref_buf = nil
  ref_view.ns = nil
  ref_view.augroup = nil
end

local function open_ref_view()
  local src_win = vim.api.nvim_get_current_win()

  vim.cmd("rightbelow vnew") -- 右に新規ウィンドウ
  local ref_win = vim.api.nvim_get_current_win()
  local ref_buf = vim.api.nvim_get_current_buf()

  -- 保存対象外のスクラッチ。閉じたら破棄して残骸を残さない
  vim.bo[ref_buf].buftype = "nofile"
  vim.bo[ref_buf].bufhidden = "wipe"
  vim.bo[ref_buf].swapfile = false

  ref_view.src_win = src_win
  ref_view.ref_win = ref_win
  ref_view.ref_buf = ref_buf
  ref_view.ns = vim.api.nvim_create_namespace("MiniRefDiffHl")
  ref_view.augroup = vim.api.nvim_create_augroup("MiniRefDiffView", { clear = true })

  vim.cmd("wincmd p") -- フォーカスを左へ戻す
  render_ref() -- 初回描画（ref 未準備なら空表示のまま、後続イベントで追従）

  -- 左ウィンドウでバッファが切り替わったら右ペインを追従させる
  -- src_win 以外（右ペインや wincmd p）での発火は無視する
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = ref_view.augroup,
    callback = function()
      if vim.api.nvim_get_current_win() == ref_view.src_win then
        render_ref()
      end
    end,
  })
  -- mini.diff の ref_text は非同期更新される。MiniDiffUpdated は対象 buf を渡さないため、
  -- 都度 src ウィンドウの現在バッファを読み直して再描画する
  vim.api.nvim_create_autocmd("User", {
    group = ref_view.augroup,
    pattern = "MiniDiffUpdated",
    callback = function()
      if ref_view.ref_win and vim.api.nvim_win_is_valid(ref_view.ref_win) then
        render_ref()
      end
    end,
  })
  -- :q 等で右ペインを直接閉じた場合も状態を確実に片付ける
  vim.api.nvim_create_autocmd("WinClosed", {
    group = ref_view.augroup,
    pattern = tostring(ref_win),
    once = true,
    callback = function()
      close_ref_view()
    end,
  })
end

-- 表示中なら閉じ、未表示なら開く（左右どちらのウィンドウからでも閉じられる）
local function toggle_ref_view()
  if ref_view.ref_win and vim.api.nvim_win_is_valid(ref_view.ref_win) then
    close_ref_view()
  else
    open_ref_view()
  end
end

h.nmap("<Leader>gd", toggle_ref_view)

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
