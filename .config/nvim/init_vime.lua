local h = require("util.helper")

require("config.options")
require("config.keymaps")

vim.opt.laststatus = 0
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup({
  {
    "arrow2nd/aqua",
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme aqua]])
    end,
  },
  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      h.imap("<C-j>", "<Plug>(skkeleton-enable)")

      local dictionaries = {}
      local handle = io.popen("ls $HOME/.skk/*")
      if handle then
        for file in handle:lines() do
          table.insert(dictionaries, file)
        end
        handle:close()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-pre",
        callback = function()
          vim.fn["skkeleton#config"]({
            eggLikeNewline = true,
            registerConvertResult = true,
            globalDictionaries = dictionaries,
          })
        end,
      })
    end,
  },
  {
    "Shougo/ddc.vim",
    dependencies = {
      "vim-denops/denops.vim",
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "skkeleton-initialize-post",
        callback = function()
          local patch_global = vim.fn["ddc#custom#patch_global"]
          patch_global("ui", "pum")
          patch_global("sources", { "skkeleton" })
          patch_global("sourceOptions", {
            skkeleton = {
              mark = "[SKK]",
              matchers = { "skkeleton" },
              isVolatile = true,
              minAutoCompleteLength = 2,
            },
          })

          vim.fn["ddc#enable"]()
        end,
      })
    end,
  },
  {
    "Shougo/pum.vim",
    config = function()
      vim.fn["pum#set_option"]({
        auto_select = true,
        padding = true,
        border = "single",
        preview = false,
        scrollbar_char = "▋",
        highlight_normal_menu = "Normal",
      })

      -- keymaps
      local opts = { silent = true, noremap = true }
      h.imap("<c-n>", "<Cmd>call pum#map#select_relative(+1)<CR>", opts)
      h.imap("<c-p>", "<Cmd>call pum#map#select_relative(-1)<CR>", opts)
      h.imap("<C-y>", "<Cmd>call pum#map#confirm()<CR>", opts)
      h.imap("<C-e>", "<Cmd>call pum#map#cancel()<CR>", opts)
    end,
  },
}, {
  install = { colorscheme = { "aqua" } },
  performance = {
    defaults = { lazy = false },
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "shada",
        "rplugin",
        "man",
      },
    },
  },
})
