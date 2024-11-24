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
h.nmap("<ESC><ESC>", "<CMD>nohlsearch<CR>", { desc = "Unhighlight" })

-- ヒストリ選択
h.omap("<C-p>", "<Up>")
h.omap("<C-n>", "<Down>")

-- quickfix
h.nmap("[q", "<Cmd>cprevious<CR>")
h.nmap("]q", "<Cmd>cnext<CR>")

-- ESCでターミナルを抜ける
h.tmap("<ESC>", "<C-\\><C-n>")

-- toggleterm
local h = require("util.helper")
h.nmap("<Leader><Space>", "<CMD>ToggleTerm<CR>")

-- denops-translate
h.xmap("<Leader>t", "<Plug>(Translate)")

-- git-messenger
h.nmap("<C-k>", "<CMD>GitMessenger<CR>", { desc = "Show git blame on the current line" })

-- copilot.vim
h.imap("<C-CR>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
})

-- copilot-chat
for _, mode in pairs({ "n", "x" }) do
	h[mode .. "map"]("<Leader>cc", "<Cmd>CopilotChat<CR>")
	h[mode .. "map"]("<Leader>cr", "<Cmd>CopilotChatReview<CR>")
	h[mode .. "map"]("<Leader>cf", "<Cmd>CopilotChatFix<CR>")
	h[mode .. "map"]("<Leader>co", "<Cmd>CopilotChatOptimize<CR>")
	h[mode .. "map"]("<Leader>cd", "<Cmd>CopilotChatDocs<CR>")
	h[mode .. "map"]("<Leader>ct", "<Cmd>CopilotChatTests<CR>")
end

-- gin.vim
h.nmap("<Leader>ga", "<CMD>Gin add %<CR>")
h.nmap("<Leader>gu", "<CMD>Gin restore --staged %<CR>")
h.nmap("<Leader>gs", "<CMD>GinStatus ++opener=split<CR>")
h.nmap("<Leader>gc", "<CMD>Gin commit -v<CR>")
h.nmap("<Leader>gd", "<CMD>GinBuffer diff<CR>")
h.nmap("<Leader>gl", "<CMD>GinLog --graph --pretty --no-show-signature<CR>")
h.nmap("<Leader>gP", "<CMD>Gin push origin HEAD<CR>")
