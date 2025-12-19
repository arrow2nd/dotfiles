local h = require("util.helper")

-- リーダーキー
vim.g.mapleader = " "

-- 行移動
h.nmap("j", "gj")
h.nmap("k", "gk")
h.nmap("gj", "j")
h.nmap("gk", "k")

-- タブ
h.nmap("]t", "<CMD>tabnext<CR>", { desc = "Switch to next tab" })
h.nmap("[t", "<CMD>tabprevious<CR>", { desc = "Switch to previous tab" })
h.nmap("<Leader>tn", "<CMD>tabnew<CR>", { desc = "Create new tab" })
h.nmap("<Leader>tc", "<CMD>tabclose<CR>", { desc = "Close tab" })

-- バッファ
h.nmap("]b", "<CMD>bnext<CR>", { desc = "Switch to next buffer" })
h.nmap("[b", "<CMD>bprevious<CR>", { desc = "Switch to previous buffer" })

-- ハイライト解除
h.nmap("<ESC>", "<CMD>nohlsearch<CR>", { desc = "Unhighlight" })

-- ヒストリ選択
h.omap("<C-p>", "<Up>")
h.omap("<C-n>", "<Down>")

-- quickfix
h.nmap("[q", "<Cmd>cprevious<CR>")
h.nmap("]q", "<Cmd>cnext<CR>")

-- ESCでターミナルを抜ける
h.tmap("<ESC>", "<C-\\><C-n>")

-- git-messenger
h.nmap("<C-k>", "<CMD>GitMessenger<CR>")

-- zen-mode
h.nmap("<Leader>z", "<CMD>ZenMode<CR>")

-- git
h.nmap("<Leader>gc", "<CMD>Git commit -v<CR>")
h.nmap("<Leader>gp", "<CMD>Git pull origin HEAD<CR>")
h.nmap("<Leader>gP", "<CMD>Git push origin HEAD<CR>")
