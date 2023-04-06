local h = require('util.helper')

return {
  {
    'Shougo/ddu.vim',
    lazy = false,
    dependencies = {
      'vim-denops/denops.vim',
      -- UI
      'Shougo/ddu-ui-filer',
      'Shougo/ddu-ui-ff',
      -- Source
      'Shougo/ddu-source-action',
      'Shougo/ddu-source-file',
      'Shougo/ddu-source-file_rec',
      'Shougo/ddu-source-line',
      'shun/ddu-source-rg',
      'shun/ddu-source-buffer',
      'matsui54/ddu-source-help',
      {
        "kuuote/ddu-source-mr",
        dependencies = { "lambdalisue/mr.vim" },
      },
      -- Filter
      {
        'Milly/ddu-filter-kensaku',
        dependencies = { 'lambdalisue/kensaku.vim' },
      },
      -- Kind
      'Shougo/ddu-kind-file',
      'Shougo/ddu-kind-word',
      -- Column
      'ryota2357/ddu-column-icon_filename',
      -- ui-select
      'matsui54/ddu-vim-ui-select',
      -- Command
      'Shougo/ddu-commands.vim',
    },
    init = function()
      h.nmap(';f', '<Cmd>Ddu file_rec -ui-param-startFilter<CR>')
      h.nmap(';h', '<Cmd>Ddu help -ui-param-startFilter<CR>')
      h.nmap(';B', '<Cmd>Ddu -name=with_preview buffer<CR>')
      h.nmap(';l', '<Cmd>Ddu -name=with_preview line<CR>')
      h.nmap(';u', '<Cmd>Ddu -name=with_preview mr<CR>')
      h.nmap(';w', '<Cmd>Ddu -name=with_preview mr -source-param-kind="mrw"<CR>')
      h.nmap(';g', function()
        vim.fn['ddu#start']({ name = 'grep' })
      end)
      h.nmap(';b', function()
        vim.fn['ddu#start']({
          name = 'filer',
          searchPath = vim.fn.expand('%:p'),
        })
      end)
    end,
    config = function()
      local reset_ui = function()
        local w = vim.api.nvim_win_get_width(0)
        local win_width = math.floor(w * 0.8)
        local win_height = 16

        vim.fn['ddu#custom#patch_global']({
          ui = 'ff',
          uiParams = {
            _ = {
              split = 'floating',
              filterSplitDirection = 'floating',
              winWidth = win_width,
              winHeight = win_height,
              winCol = math.floor((w - win_width) / 2),
              winRow = math.floor((vim.api.nvim_win_get_height(0) - win_height) / 2) + 1,
              preview = true,
              previewFloating = true,
              previewSplit = 'horizontal',
              previewWidth = win_width,
              previewHeight = 12,
              autoResize = false,
            },
            filer = {
              winWidth = math.floor(w / 2),
              winCol = math.floor(w / 4),
              previewWidth = math.floor(w / 2),
            }
          },
        })
      end

      reset_ui()
      vim.api.nvim_create_autocmd('VimResized', {
        pattern = '*',
        callback = reset_ui,
      })

      vim.fn['ddu#custom#patch_global']({
        sourceParams = {
          file_rec = {
            ignoredDirectories = { '.git', 'node_modules', '.next' },
          },
          rg = {
            inputType = 'migemo',
            args = { '--json', '--column', '--no-heading', '--color', 'never', '--hidden', '--glob', '!.git' },
          },
        },
        sourceOptions = {
          _ = {
            ignoreCase = true,
            matchers = { 'matcher_kensaku' },
          },
        },
        filterParams = {
          matcher_kensaku = {
            highlightMatched = 'Search',
          },
        },
        kindOptions = {
          file = {
            defaultAction = 'open',
          },
          help = {
            defaultAction = 'open',
          },
          action = {
            defaultAction = 'do',
          },
          word = {
            defaultAction = 'append',
          },
          ui_select = {
            defaultAction = 'select',
          },
        },
        actionOptions = {
          narrow = {
            quit = false,
          },
        },
      })

      local ui_params_preview = {
        ff = {
          ignoreEmpty = false,
          startFilter = true,
          autoAction = { name = 'preview' },
        },
      }

      -- With preview
      vim.fn['ddu#custom#patch_local']('with_preview', {
        uiParams = ui_params_preview,
      })

      -- Live grep
      vim.fn['ddu#custom#patch_local']('grep', {
        volatile = true,
        sources = {
          { name = 'rg' },
        },
        uiParams = ui_params_preview,
      })

      -- Filer
      vim.fn['ddu#custom#patch_local']('filer', {
        ui = 'filer',
        sources = {
          {
            name = 'file',
            params = {},
          },
        },
        sourceOptions = {
          _ = {
            columns = { 'icon_filename' },
          },
        },
      })

      -- keymaps
      local opts = { buffer = true, silent = true, noremap = true }
      local nowait = { buffer = true, silent = true, noremap = true, nowait = true }

      local common_keymaps = function()
        vim.wo.cursorline = true
        h.nmap('<CR>', '<Cmd>call ddu#ui#do_action("itemAction")<CR>', opts)
        h.nmap('os', '<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "split"}})<CR>',
          opts)
        h.nmap('ov', '<Cmd>call ddu#ui#do_action("itemAction", {"name": "open", "params": {"command": "vsplit"}})<CR>',
          opts)
        h.nmap('<SPACE>', '<Cmd>call ddu#ui#do_action("toggleSelectItem")<CR>', opts)
        h.nmap('<ESC>', '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)
        h.nmap('q', '<Cmd>call ddu#ui#do_action("quit")<CR>', nowait)
        h.nmap('a', '<Cmd>call ddu#ui#do_action("chooseAction")<CR>', opts)
        h.nmap('K', '<Cmd>call ddu#ui#do_action("preview")<CR>', opts)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = 'ddu-filer',
        callback = function()
          common_keymaps()
          -- ファイル操作
          h.nmap('c', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "copy"})<CR>', opts)
          h.nmap('yy', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "yank"})<CR>', opts)
          h.nmap('p', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "paste"})<CR>', opts)
          h.nmap('D', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "delete"})<CR>', opts)
          h.nmap('r', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "rename"})<CR>', opts)
          h.nmap('m', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "move"})<CR>', opts)
          h.nmap('n', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "newFile"})<CR>', opts)
          h.nmap('N', '<Cmd>call ddu#ui#ff#do_action("itemAction", {"name": "newDirectory"})<CR>', opts)
          -- ディレクトリの展開
          h.nmap('h', '<Cmd>call ddu#ui#do_action("expandItem", {"mode": "toggle"})<CR>', opts)
          h.nmap('l', '<Cmd>call ddu#ui#do_action("expandItem", {"mode": "toggle"})<CR>', opts)
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'ddu-ff',
        callback = function()
          common_keymaps()
          h.nmap('i', '<Cmd>call ddu#ui#ff#do_action("openFilterWindow")<CR>', opts)
          -- 一括でQuickfixに流しこむ
          h.nmap('Q', function()
            vim.fn['ddu#ui#ff#multi_actions']({
              { 'clearSelectAllItems' },
              { 'toggleAllItems' },
              {
                'itemAction',
                { name = 'quickfix' },
              },
            })
          end, opts)
        end,
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'ddu-ff-filter',
        callback = function()
          h.nmap('q', '<Cmd>close<CR>', nowait)
          h.nmap('<ESC>', '<Cmd>close<CR>', nowait)
          h.imap('<CR>', '<Cmd>call ddu#ui#ff#do_action("itemAction")<CR>', opts)
          h.imap('<C-j>', [[<Cmd>call ddu#ui#ff#execute('call cursor(line(".") + 1, 0)<Bar>redraw')<CR>]], opts)
          h.imap('<C-k>', [[<Cmd>call ddu#ui#ff#execute('call cursor(line(".") - 1, 0)<Bar>redraw')<CR>]], opts)
          h.imap('<C-n>', function() vim.cmd('execute("normal! k")') end, opts)
          h.imap('<C-p>', function() vim.cmd('execute("normal! j")') end, opts)
        end,
      })
    end
  }
}
