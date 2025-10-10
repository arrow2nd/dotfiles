local h = require("util.helper")

-- Store active sidekick terminal instance globally
_G.sidekick_active_terminal = nil

require("sidekick").setup({
  cli = {
    win = {
      keys = {
        stopinsert = { "<esc><esc>", "stopinsert", mode = "t" }, -- enter normal mode
        hide_n = { "q", "hide", mode = "n" }, -- hide from normal mode
        prompt = { "<c-p>", "prompt" }, -- insert prompt or context
        insert_from_buffer = {
          "<c-n>",
          function(t)
            -- Store the sidekick instance globally
            _G.sidekick_active_terminal = t

            local bufnr = vim.fn.bufnr("sidekick://prompt")
            if bufnr ~= -1 then
              local winid = vim.fn.bufwinid(bufnr)
              if winid ~= -1 then
                vim.api.nvim_set_current_win(winid)
              else
                vim.cmd(":drop sidekick://prompt")
              end
            else
              vim.cmd(":10new sidekick://prompt")
            end
          end,
        },
      },
    },
  },
})

-- サジェストの受け入れ
for _, mode in pairs({ "n", "i" }) do
  h[mode .. "map"]("<c-cr>", function()
    -- if there is a next edit, jump to it, otherwise apply it if any
    if require("sidekick").nes_jump_or_apply() then
      return -- jumped or applied
    end

    -- if you are using Neovim's native inline completions
    if vim.lsp.inline_completion.get() then
      return
    end

    return "<c-cr>"
  end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })
end

-- フォーカス移動
for _, mode in pairs({ "n", "x", "i", "t" }) do
  h[mode .. "map"]("<c-.>", function()
    require("sidekick.cli").focus()
  end, { desc = "Sidekick Switch Focus" })
end

for _, mode in pairs({ "n", "v" }) do
  -- CLIのトグル
  h[mode .. "map"]("<leader>aa", function()
    require("sidekick.cli").toggle({ focus = true })
  end, { desc = "Sidekick Toggle CLI" })

  -- Claude Code
  h[mode .. "map"]("<leader>ac", function()
    require("sidekick.cli").toggle({ name = "claude", focus = true })
  end, { desc = "Sidekick Claude Toggle" })

  -- Codex
  h[mode .. "map"]("<leader>ao", function()
    require("sidekick.cli").toggle({ name = "codex", focus = true })
  end, { desc = "Sidekick Codex Toggle" })

  -- プロンプト選択
  h[mode .. "map"]("<leader>ap", function()
    require("sidekick.cli").select_prompt()
  end, { desc = "Sidekick Ask Prompt" })
end

-- 現在のバッファのファイル名をSidekickの入力欄に送る
for _, mode in pairs({ "n", "v" }) do
  h[mode .. "map"]("<leader>ab", function()
    local buf = vim.api.nvim_get_current_buf()

    -- ノーマルモードではファイル名のみ、ビジュアルモードでは行・列情報も含める
    local kind = mode == "n" and "file" or "position"
    local ctx = require("sidekick.cli.context").ctx()
    ctx.buf = buf
    local loc_text = require("sidekick.cli.context.location").get(ctx, { kind = kind })
    local Text = require("sidekick.text")
    local loc = " " .. table.concat(Text.lines(loc_text), "\n")

    -- ビジュアルモードの場合は選択を解除
    if mode == "v" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end

    -- Sidekickを開いて、ファイル情報を送信
    local cli = require("sidekick.cli")

    -- まず表示してフォーカス
    cli.show({
      name = "claude",
      focus = true,
    })

    -- 少し待ってからファイル情報を送信
    vim.defer_fn(function()
      local State = require("sidekick.cli.state")
      State.with(function(state)
        if state.session and loc then
          state.session:send(loc)
        end
      end, {
        filter = { name = "claude" },
      })
    end, 100)
  end)
end

-- 一時的なバッファを作成し、Sidekickの入力欄として利用する
vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
  pattern = { "sidekick://prompt" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.api.nvim_set_option_value("filetype", "markdown", { buf = bufnr })
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
    vim.api.nvim_set_option_value("buflisted", false, { buf = bufnr })

    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<Cmd>q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<c-n>", "<Cmd>q<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "Q", "<Cmd>q!<CR>", { noremap = true, silent = true })

    vim.schedule(function()
      vim.cmd("startinsert")
    end)

    h.nmap("<CR>", function()
      local sidekick_t = _G.sidekick_active_terminal

      if not sidekick_t then
        vim.notify("No active Sidekick instance found", vim.log.levels.ERROR)
        return
      end

      local current_win = vim.api.nvim_get_current_win()
      local prompt = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      -- Send the prompt content to sidekick
      sidekick_t:send(table.concat(prompt, "\n"))

      -- Focus back to sidekick window
      if sidekick_t:is_open() then
        sidekick_t:focus()
      end

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
