local opt = vim.opt

-- 文字
vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- 24bitカラー
opt.termguicolors = true

-- statusline を下部に固定
-- NOTE: pum.vimのポップアップを出すとなんかチラつくのでやめてる
opt.laststatus = 3

-- ウィンドウのボーダー
opt.fillchars = {
  horiz = "━",
  horizup = "┻",
  horizdown = "┳",
  vert = "┃",
  vertleft = "┫",
  vertright = "┣",
  verthoriz = "╋",
}

-- windowのボーダー
vim.o.winborder = "single"

-- intro を非表示
opt.shortmess = "I"

-- 行
opt.number = true
opt.nuw = 4
opt.signcolumn = "yes"
opt.cursorline = true

-- ヘルプの言語
opt.helplang = "ja"

-- バックアップ, スワップファイル
opt.backup = false
opt.swapfile = false

-- buffer切り替え時の未保存警告をオフ
opt.hidden = true

-- 行末までカーソルを移動可能に
opt.virtualedit = "onemore"

-- マウス操作有効化
opt.mouse = "a"

-- 不可視文字可視化
opt.list = true
opt.listchars = { tab = "▸ ", trail = "⋅", nbsp = "␣", extends = "❯", precedes = "❮" }

-- タブ, インデント
opt.tabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true

-- 折り畳み
opt.foldmethod = "indent"
vim.opt.foldlevel = 99

-- 折り畳みのテキストをいい感じにする
-- @see https://mogulla3.tech/articles/2024-10-14-customising-neovim-folds-for-ease-of-use/
function Foldtext()
  local line = vim.fn.getline(vim.v.foldstart)
  local count = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%s (%d lines folded)", line, count)
end

vim.opt.foldtext = "v:lua.Foldtext()"
vim.opt.fillchars = { fold = " " }

-- 括弧
opt.showmatch = true
opt.matchtime = 1

-- 検索
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- ヒストリの上限
opt.history = 512

-- 補完
opt.completeopt = "menuone,noinsert"
opt.pumheight = 24

-- LTSのNodeを使うように
---NOTE: プロジェクトのNodeのバージョンが14.xとかだと、LSPによっては動かないことがあるため
local home_dir = vim.fn.expand("$HOME")
local node_bin = "/.local/share/mise/installs/node/lts/bin"

vim.g.node_host_prog = home_dir .. node_bin .. "/node"
vim.cmd("let $PATH = '" .. home_dir .. node_bin .. ":' . $PATH")

-- LSPの警告フォーマット
-- ref: https://dev.classmethod.jp/articles/eetann-change-neovim-lsp-diagnostics-format/
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = {
    format = function(diagnostic)
      if not diagnostic.source then
        return diagnostic.message
      end

      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})

-- 数字だけのシンプルなタブライン
function TabLine()
  local s = ""
  local tab_length = vim.fn.tabpagenr("$")
  if tab_length <= 1 then
    return s
  end

  for i = 1, tab_length do
    -- select the highlighting
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    s = s .. " " .. tostring(i) .. " "
  end

  return s .. "%#TabLineFill#%T"
end

opt.tabline = "%!v:lua.TabLine()"
