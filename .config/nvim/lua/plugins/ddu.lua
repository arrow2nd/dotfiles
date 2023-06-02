local h = require("util.helper")

return {
  {
    "Shougo/ddu.vim",
    lazy = false,
    enabled = true,
    dependencies = {
      "vim-denops/denops.vim",
      -- UI
      "Shougo/ddu-ui-filer",
      "Shougo/ddu-ui-ff",
      -- Source
      "Shougo/ddu-source-action",
      "Shougo/ddu-source-file",
      "Shougo/ddu-source-file_old",
      "matsui54/ddu-source-file_external",
      "Shougo/ddu-source-line",
      "shun/ddu-source-rg",
      "shun/ddu-source-buffer",
      "matsui54/ddu-source-help",
      "uga-rosa/ddu-source-nvim_lsp",
      -- Filter
      "Shougo/ddu-filter-sorter_alpha",
      {
        "Milly/ddu-filter-kensaku",
        dependencies = { "lambdalisue/kensaku.vim" },
      },
      -- Kind
      "Shougo/ddu-kind-file",
      "Shougo/ddu-kind-word",
      -- Column
      "ryota2357/ddu-column-icon_filename",
      -- ui-select
      "matsui54/ddu-vim-ui-select",
      -- Command
      "Shougo/ddu-commands.vim",
    },
    init = function()
      h.nmap(";f", "<Cmd>Ddu file_external<CR>")
      h.nmap(";h", "<Cmd>Ddu help<CR>")
      h.nmap(";B", "<Cmd>Ddu buffer<CR>")
      h.nmap(";l", "<Cmd>Ddu line<CR>")
      h.nmap(";o", "<Cmd>Ddu file_old<CR>")
      h.nmap(";g", "<Cmd>Ddu -name=grep<CR>")
      h.nmap(";b", [[<Cmd>Ddu -name=filer -searchPath=`expand('%:p')`<CR>]])
    end,
    config = function()
      local reset_ui = function()
        local width = vim.api.nvim_eval("&columns")
        local height = vim.api.nvim_eval("&lines")
        local win_width = math.floor(width * 0.8)
        local win_height = 16
        local preview_height = 14

        vim.fn["ddu#custom#patch_global"]({
          ui = "ff",
          uiParams = {
            _ = {
              winWidth = win_width,
              winHeight = win_height,
              winCol = math.floor((width - win_width) / 2),
              split = "floating",
              filterSplitDirection = "floating",
              floatingBorder = "rounded",
              preview = true,
              previewFloating = true,
              previewFloatingBorder = "rounded",
              previewSplit = "horizontal",
              previewWidth = math.floor(win_width / 2),
              previewHeight = preview_height,
              highlights = {
                floating = "Normal",
                floatingBorder = "Normal",
              },
              autoResize = false,
            },
            ff = {
              winRow = math.floor((height - win_height) / 2) + preview_height / 2 - 1,
              startFilter = true,
              autoAction = { name = "preview" },
              ignoreEmpty = false,
            },
            filer = {
              winRow = math.floor((height - win_height) / 2),
            },
          },
        })
      end

      reset_ui()

      -- 幅を再計算するために画面がリサイズされたら再設定する
      vim.api.nvim_create_autocmd("VimResized", {
        pattern = "*",
        callback = reset_ui,
      })

      vim.fn["ddu#custom#patch_global"]({
        sourceParams = {
          file_external = {
            cmd = { "fd", ".", "-H", "-E", ".git", "-t", "f" },
          },
          rg = {
            inputType = "migemo",
            args = { "--json", "--column", "--no-heading", "--color", "never", "--hidden", "--glob", "!.git" },
          },
        },
        sourceOptions = {
          _ = {
            ignoreCase = true,
            matchers = { "matcher_kensaku" },
            sorters = { "sorter_alpha" },
          },
        },
        kindOptions = {
          file = {
            defaultAction = "open",
          },
          nvim_lsp = {
            defaultAction = "open",
          },
          help = {
            defaultAction = "open",
          },
          action = {
            defaultAction = "do",
          },
          word = {
            defaultAction = "append",
          },
          ui_select = {
            defaultAction = "select",
          },
        },
      })

      -- Live grep
      vim.fn["ddu#custom#patch_local"]("grep", {
        sources = {
          { name = "rg" },
        },
        sourceOptions = {
          rg = {
            volatile = true,
          },
        },
      })

      -- nvim_lsp
      for name, method in pairs({
        lsp_declaration = "textDocument/declaration",
        lsp_definitions = "textDocument/definition",
        lsp_references = "textDocument/references",
      }) do
        vim.fn["ddu#custom#patch_local"](name, {
          sync = true,
          sources = {
            { name = "nvim_lsp" },
          },
          sourceParams = {
            nvim_lsp = {
              method = method,
            },
          },
          uiParams = {
            ff = {
              immediateAction = "open",
            },
          },
        })
      end

      -- Filer
      vim.fn["ddu#custom#patch_local"]("filer", {
        ui = "filer",
        sync = true,
        sources = {
          { name = "file" },
        },
        sourceOptions = {
          _ = {
            columns = { "icon_filename" },
          },
        },
        actionOptions = {
          narrow = {
            quit = false,
          },
        },
      })

      -- keymaps
      local opts = { buffer = true, silent = true, noremap = true }
      local nowait = { buffer = true, silent = true, noremap = true, nowait = true }

      local common_keymaps = function()
        vim.wo.cursorline = true
        h.nmap("<CR>", '<Cmd>call ddu#ui#do_action("itemAction")<CR>', opts)
        h.nmap(
          "os",
          '<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "split"}})<CR>',
          opts
        )
        h.nmap(
          "ov",
          '<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "vsplit"}})<CR>',
          opts
        )
        h.nmap("<SPACE>", '<Cmd>call ddu#ui#do_action("toggleSelectItem")<CR>', opts)
        h.nmap("<ESC>", '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)
        h.nmap("q", '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)
        h.nmap("a", '<Cmd>call ddu#ui#do_action("chooseAction")<CR>', opts)
        h.nmap("K", '<Cmd>call ddu#ui#do_action("preview")<CR>', opts)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ddu-filer",
        callback = function()
          common_keymaps()
          -- ファイル操作
          h.nmap("y", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "copy"})<CR>', opts)
          h.nmap("p", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "paste"})<CR>', opts)
          h.nmap("x", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "delete"})<CR>', opts)
          h.nmap("r", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "rename"})<CR>', opts)
          h.nmap("m", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "move"})<CR>', opts)
          h.nmap("n", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "newFile"})<CR>', opts)
          h.nmap("N", '<Cmd>call ddu#ui#do_action("itemAction", {"name": "newDirectory"})<CR>', opts)
          -- ディレクトリなら展開、ファイルなら何もしない
          vim.cmd([[nnoremap <buffer><expr> <Tab>
             \ ddu#ui#get_item()->get('isTree', v:false)
             \ ? "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
             \ : "<Tab>"]])
          -- ディレクトリなら展開、ファイルなら開く
          vim.cmd([[nnoremap <buffer><expr> <CR>
             \ ddu#ui#get_item()->get('isTree', v:false)
             \ ? "<Cmd>call ddu#ui#do_action('expandItem', {'mode': 'toggle'})<CR>"
             \ : "<Cmd>call ddu#ui#do_action('itemAction', {'name': 'open'})<CR>"]])
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ddu-ff",
        callback = function()
          common_keymaps()
          h.nmap("i", '<Cmd>call ddu#ui#ff#do_action("openFilterWindow")<CR>', opts)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ddu-ff-filter",
        callback = function()
          h.nmap("q", "<Cmd>close<CR>", nowait)
          h.nmap("<ESC>", "<Cmd>close<CR>", nowait)
          h.imap("<CR>", '<Cmd>call ddu#ui#ff#do_action("itemAction")<CR>', opts)
          h.imap("<C-j>", [[<Cmd>call ddu#ui#ff#execute('call cursor(line(".") + 1, 0)<Bar>redraw')<CR>]], opts)
          h.imap("<C-k>", [[<Cmd>call ddu#ui#ff#execute('call cursor(line(".") - 1, 0)<Bar>redraw')<CR>]], opts)
          h.imap("<C-n>", function()
            vim.cmd('execute("normal! k")')
          end, opts)
          h.imap("<C-p>", function()
            vim.cmd('execute("normal! j")')
          end, opts)
          -- 一括でQuickfixに流しこむ
          h.imap("<C-q>", function()
            vim.fn["ddu#ui#ff#multi_actions"]({
              { "clearSelectAllItems" },
              { "toggleAllItems" },
              { "itemAction", { name = "quickfix" } },
            })
          end, opts)
        end,
      })
    end,
  },
}
