local imap = require("util.helper").imap
local fn = vim.fn

return {
  {
    "Shougo/ddc.vim",
    lazy = false,
    dependencies = {
      "vim-denops/denops.vim",
      -- UI
      "Shougo/pum.vim",
      "Shougo/ddc-ui-pum",
      -- Source
      "Shougo/ddc-source-around",
      "Shougo/ddc-source-lsp",
      "LumaKernel/ddc-source-file",
      "uga-rosa/ddc-source-vsnip",
      -- Filter
      "Shougo/ddc-filter-matcher_head",
      "Shougo/ddc-filter-sorter_rank",
      "Shougo/ddc-filter-converter_truncate_abbr",
      "Shougo/ddc-filter-converter_remove_overlap",
      -- Preview
      "uga-rosa/ddc-previewer-floating",
      "matsui54/denops-signature_help",
    },
    config = function()
      local patch_global = fn["ddc#custom#patch_global"]

      patch_global("ui", "pum")

      patch_global("sources", {
        "skkeleton",
        "lsp",
        "vsnip",
        "file",
        "around",
      })

      patch_global("sourceOptions", {
        _ = {
          matchers = { "matcher_head" },
          sorters = { "sorter_rank" },
          converters = { "converter_truncate_abbr", "converter_remove_overlap" },
          ignoreCase = true,
        },
        around = {
          mark = "[A]",
        },
        lsp = {
          mark = "[LS]",
          dup = "keep",
          keywordPattern = "[a-zA-Z0-9_À-ÿ$#\\-*]*",
          forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
          sorters = { "sorter_lsp-kind", "sorter_rank" },
        },
        file = {
          mark = "[F]",
          isVolatile = true,
          forceCompletionPattern = [[\S/\S*]],
        },
        skkeleton = {
          mark = "[SKK]",
          matchers = { "skkeleton" },
          sorters = {},
          converters = {},
          isVolatile = true,
          minAutoCompleteLength = 2,
        },
      })

      patch_global("sourceParams", {
        lsp = {
          snippetEngine = vim.fn["denops#callback#register"](function(body)
            vim.fn["vsnip#anonymous"](body)
          end),
          enableResolveItem = true,
          enableAdditionalTextEdit = true,
          confirmBehavior = "replace",
        },
      })

      fn["ddc#enable"]()
      require("ddc_previewer_floating").enable()
    end,
  },
  {
    "Shougo/pum.vim",
    config = function()
      fn["pum#set_option"]({
        auto_select = true,
        padding = true,
        border = "none",
        preview = false,
        scrollbar_char = "▋",
      })

      -- keymaps
      local opts = { silent = true, noremap = true }
      imap("<c-n>", "<Cmd>call pum#map#select_relative(+1)<CR>", opts)
      imap("<c-p>", "<Cmd>call pum#map#select_relative(-1)<CR>", opts)
      imap("<C-y>", "<Cmd>call pum#map#confirm()<CR>", opts)
      imap("<C-e>", "<Cmd>call pum#map#cancel()<CR>", opts)
    end,
  },
  {
    "uga-rosa/ddc-previewer-floating",
    config = function()
      require("ddc_previewer_floating").setup({
        ui = "pum",
        border = "single",
        window_options = {
          wrap = false,
          number = false,
          signcolumn = "no",
          cursorline = false,
          foldenable = false,
        },
      })
    end,
  },
  {
    "matsui54/denops-signature_help",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      vim.g.signature_help_config = {
        contentsStyle = "currentLabel",
        viewStyle = "virtual",
      }

      fn["signature_help#enable"]()
    end,
  },
  {
    "hrsh7th/vim-vsnip",
    lazy = false,
    config = function()
      vim.g.vsnip_snippet_dir = "~/.config/vsnip"
      vim.cmd('imap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('smap <expr> <C-l> vsnip#jumpable(1) ? "<Plug>(vsnip-jump-next)" : "<C-l>"')
      vim.cmd('imap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
      vim.cmd('smap <expr> <C-h> vsnip#jumpable(-1) ? "<Plug>(vsnip-jump-prev)" : "<C-h>"')
    end,
  },
}
