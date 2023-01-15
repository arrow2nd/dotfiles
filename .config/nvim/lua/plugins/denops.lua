local h = require("util.helper")
local fn = vim.fn

return {
  {
    "vim-denops/denops.vim",
    event = "VeryLazy",
  },
  {
    "vim-skk/skkeleton",
    event = "BufReadPre",
    init = function()
      h.imap("<C-j>", "<Plug>(skkeleton-enable)")
      h.cmap("<C-j>", "<Plug>(skkeleton-enable)")

      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-pre",
        callback = function()
          vim.fn["skkeleton#config"]({
            eggLikeNewline = true,
            skkServerPort = 1178,
            useSkkServer = true,
          })
        end
      })
    end
  },
  {
    "4513ECHO/denops-gitter.vim",
    event = "VeryLazy",
    init = function()
      vim.api.nvim_create_user_command("ReadingVimrc", "new gitter://room/vim-jp/reading-vimrc", {})
    end,
    config = function()
      local token = fn.readfile(fn.expand("~/.config/denops-gitter/.token"))
      vim.g["gitter#token"] = fn.trim(table.concat(token))
    end
  }
}
