local h = require("util.helper")

require("claudecode").setup({
  terminal = {
    provider = "native",
  },
})

-- keymaps
h.nmap("<Leader>ac", "<CMD>ClaudeCode<CR>")
h.nmap("<Leader>af", "<CMD>ClaudeCodeFocus<CR>")
h.nmap("<Leader>ar", "<CMD>ClaudeCode --resume<CR>")
h.nmap("<Leader>aC", "<CMD>ClaudeCode --continue<CR>")
h.nmap("<Leader>ab", "<CMD>ClaudeCodeAdd %<CR>")
h.vmap("<Leader>ab", "<CMD>ClaudeCodeSend<CR>")
h.nmap("<Leader>aa", "<CMD>ClaudeCodeDiffAccept<CR>")
h.nmap("<Leader>ad", "<CMD>ClaudeCodeDiffDeny<CR>")

-- thanks!: https://github.com/skanehira/dotfiles/blob/b119bf6d57fb46052ac3c7b670428989ea6dfb67/vim/lua/plugins/ai/claudecode.lua
h.nmap("<Leader>an", function()
  local bufnr = vim.fn.bufnr("claudecode://prompt")
  if bufnr ~= -1 then
    local winid = vim.fn.bufwinid(bufnr)
    if winid ~= -1 then
      vim.api.nvim_set_current_win(winid)
    else
      vim.cmd(":drop claudecode://prompt")
    end
  else
    vim.cmd(":10new claudecode://prompt")
  end
end)

vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "claudecode://prompt" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
    vim.api.nvim_set_option_value("buflisted", false, { buf = bufnr })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<Cmd>q<CR>", { noremap = true, silent = true })

    vim.cmd("startinsert")

    h.nmap("<CR>", function()
      local claude_terminal_bufnr = require("claudecode.terminal").get_active_terminal_bufnr()
      if not claude_terminal_bufnr then
        return
      end
      local terminal_job_id = vim.fn.getbufvar(claude_terminal_bufnr, "terminal_job_id")
      if not terminal_job_id then
        return
      end

      local current_win = vim.api.nvim_get_current_win()
      local prompt = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      vim.fn.chansend(terminal_job_id, prompt)
      vim.cmd("ClaudeCodeFocus")
      vim.defer_fn(function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
        vim.defer_fn(function()
          vim.api.nvim_set_current_win(current_win)
          vim.cmd("bw!")
        end, 100)
      end, 100)
    end, { noremap = true, silent = true, buffer = true })
  end,
})
