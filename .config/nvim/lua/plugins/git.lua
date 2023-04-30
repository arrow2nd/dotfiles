local h = require('util.helper')

return {
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gvdiffsplit' },
    init = function()
      h.nmap('<Leader>gs', '<CMD>Git<CR>', { desc = 'git status' })
      h.nmap('<Leader>gc', '<CMD>Git commit<CR>', { desc = 'git commit' })
      h.nmap('<Leader>gb', '<CMD>Git blame<CR>', { desc = 'git blame' })
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      h.nmap('<Leader>hp', '<CMD>Gitsigns preview_hunk<CR>', { desc = 'Show preview the hunk' })
      h.nmap('<Leader>hs', '<CMD>Gitsigns stage_hunk<CR>', { desc = 'Stage the hunk' })
      h.nmap('<Leader>hu', '<CMD>Gitsigns undo_stage_hunk<CR>', { desc = 'Undo the last call of stage hunk' })
      h.nmap('<Leader>hr', '<CMD>Gitsigns reset_hunk<CR>', { desc = 'Reset the lines of the hunk' })
    end,
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '*' },
          delete = { text = '-' },
          topdelete = { text = '-' },
          changedelete = { text = '*' },
        },
        preview_config = {
          border = 'none',
          style = 'minimal',
        },
      })
    end
  },
  {
    'rhysd/git-messenger.vim',
    cmd = 'GitMessenger',
    init = function()
      h.nmap('<C-k>', '<CMD>GitMessenger<CR>', { desc = 'Show git blame on the current line' })
    end
  },
  {
    'sindrets/diffview.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    init = function()
      h.nmap('<Leader>gd', '<CMD>DiffviewOpen<CR>', { desc = 'Show git diff' })
      h.nmap('<Leader>gh', '<CMD>DiffviewFileHistory<CR>', { desc = 'Show current branch file history' })
      h.nmap('<Leader>gl', '<CMD>DiffviewFileHistory %<CR>', { desc = 'Show current file history' })
    end,
    config = function()
      local act = require('diffview.actions')

      require('diffview').setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        use_icons = true,
        show_help_hints = true,
        watch_index = true,
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
          done = '✓',
        },
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = false,
          },
          merge_tool = {
            layout = 'diff3_horizontal',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
            winbar_info = false,
          },
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 32,
            win_opts = {}
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = { diff_merges = 'combined' },
              multi_file = { diff_merges = 'first-parent' },
            },
            hg = {
              single_file = {},
              multi_file = {},
            },
          },
          win_config = {
            position = 'bottom',
            height = 16,
            win_opts = {}
          },
        },
        commit_log_panel = {
          win_config = {
            win_opts = {},
          }
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewFileHistory = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = true,
          view = {
            { 'n', '<ESC>',      act.close,                     { desc = 'Close view' } },
            { 'n', 'q',          act.close,                     { desc = 'Close view' } },
            { 'n', '<TAB>',      act.select_next_entry,         { desc = 'Open the diff for the next file' } },
            { 'n', '<S-TAB>',    act.select_prev_entry,         { desc = 'Open the diff for the previous file' } },
            { 'n', '<C-n>',      act.select_next_entry,         { desc = 'Open the diff for the next file' } },
            { 'n', '<C-p>',      act.select_prev_entry,         { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf',         act.goto_file_edit,            { desc = 'Open the file in the previous tabpage' } },
            { 'n', 'gF',         act.goto_file_tab,             { desc = 'Open the file in a new tabpage' } },
            { 'n', '<Leader>e',  act.focus_files,               { desc = 'Bring focus to the file panel' } },
            { 'n', '<Leader>b',  act.toggle_files,              { desc = 'Toggle the file panel.' } },
            { 'n', 'gx',         act.cycle_layout,              { desc = 'Cycle through available layouts.' } },
            { 'n', 'x[',         act.prev_conflict,             { desc = 'Merge-tool: jump to the previous conflict' } },
            { 'n', 'x]',         act.next_conflict,             { desc = 'Merge-tool: jump to the next conflict' } },
            { 'n', '<Leader>co', act.conflict_choose('ours'),   { desc = 'Choose the OURS version of a conflict' } },
            { 'n', '<Leader>ct', act.conflict_choose('theirs'), { desc = 'Choose the THEIRS version of a conflict' } },
            { 'n', '<Leader>cb', act.conflict_choose('base'),   { desc = 'Choose the BASE version of a conflict' } },
            { 'n', '<Leader>ca', act.conflict_choose('all'),    { desc = 'Choose all the versions of a conflict' } },
            { 'n', 'dx',         act.conflict_choose('none'),   { desc = 'Delete the conflict region' } },
          },
          diff1 = {
            { 'n', '?', act.help({ 'view', 'diff1' }), { desc = 'Open the help panel' } },
          },
          diff2 = {
            { 'n', '?', act.help({ 'view', 'diff2' }), { desc = 'Open the help panel' } },
          },
          diff3 = {
            {
              { 'n', 'x' }, '2do', act.diffget('ours'),
              {
                desc = 'Obtain the diff hunk from the OURS version of the file',
              },
            },
            {
              { 'n', 'x' }, '3do', act.diffget('theirs'),
              {
                desc = 'Obtain the diff hunk from the THEIRS version of the file',
              },
            },
            { 'n', '?', act.help({ 'view', 'diff3' }), { desc = 'Open the help panel' } }
          },
          diff4 = {
            -- Mappings in 4-way diff layouts
            {
              { 'n', 'x' }, '1do', act.diffget('base'),
              {
                desc = 'Obtain the diff hunk from the BASE version of the file',
              }
            },
            {
              { 'n', 'x' }, '2do', act.diffget('ours'),
              {
                desc = 'Obtain the diff hunk from the OURS version of the file',
              },
            },
            {
              { 'n', 'x' }, '3do', act.diffget('theirs'),
              {
                desc = 'Obtain the diff hunk from the THEIRS version of the file',
              },
            },
            { 'n', '?', act.help({ 'view', 'diff4' }), { desc = 'Open the help panel' } },
          },
          file_panel = {
            { 'n', '<ESC>',     act.close,               { desc = 'Close file panel' } },
            { 'n', 'q',         act.close,               { desc = 'Close file panel' } },
            { 'n', 'j',         act.next_entry,          { desc = 'Bring the cursor to the next file entry' } },
            { 'n', '<DOWN>',    act.next_entry,          { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k',         act.prev_entry,          { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<UP>',      act.prev_entry,          { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<CR>',      act.select_entry,        { desc = 'Open the diff for the selected entry.' } },
            { 'n', '-',         act.toggle_stage_entry,  { desc = 'Stage / unstage the selected entry.' } },
            { 'n', 'S',         act.stage_all,           { desc = 'Stage all entries.' } },
            { 'n', 'U',         act.unstage_all,         { desc = 'Unstage all entries.' } },
            { 'n', 'X',         act.restore_entry,       { desc = 'Restore entry to the state on the left side.' } },
            { 'n', 'L',         act.open_commit_log,     { desc = 'Open the commit log panel.' } },
            { 'n', '<C-b>',     act.scroll_view(-0.25),  { desc = 'Scroll the view up' } },
            { 'n', '<C-f>',     act.scroll_view(0.25),   { desc = 'Scroll the view down' } },
            { 'n', '<C-j>',     act.select_next_entry,   { desc = 'Open the diff for the next file' } },
            { 'n', '<C-k>',     act.select_prev_entry,   { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf',        act.goto_file_edit,      { desc = 'Open the file in the previous tabpage' } },
            { 'n', 'gF',        act.goto_file_tab,       { desc = 'Open the file in a new tabpage' } },
            { 'n', 'i',         act.listing_style,       { desc = 'Toggle between "list " and "tree " views' } },
            { 'n', 'f',         act.toggle_flatten_dirs, { desc = 'Flatten empty subdirectories in tree listing style.' } },
            { 'n', 'R',         act.refresh_files,       { desc = 'Update stats and entries in the file list.' } },
            { 'n', '<Leader>e', act.focus_files,         { desc = 'Bring focus to the file panel' } },
            { 'n', '<Leader>b', act.toggle_files,        { desc = 'Toggle the file panel' } },
            { 'n', 'gx',        act.cycle_layout,        { desc = 'Cycle available layouts' } },
            { 'n', 'x]',        act.prev_conflict,       { desc = 'Go to the previous conflict' } },
            { 'n', 'x[',        act.next_conflict,       { desc = 'Go to the next conflict' } },
            { 'n', '?',         act.help('file_panel'),  { desc = 'Open the help panel' } },
          },
          file_history_panel = {
            { 'n', '<ESC>',     act.close,                      { desc = 'Close file panel' } },
            { 'n', 'q',         act.close,                      { desc = 'Close file panel' } },
            { 'n', '!',         act.options,                    { desc = 'Open the option panel' } },
            { 'n', '<C-A-d>',   act.open_in_diffview,           { desc = 'Open the entry under the cursor in a diffview' } },
            { 'n', 'L',         act.open_commit_log,            { desc = 'Show commit details' } },
            { 'n', 'zR',        act.open_all_folds,             { desc = 'Expand all folds' } },
            { 'n', 'zM',        act.close_all_folds,            { desc = 'Collapse all folds' } },
            { 'n', 'j',         act.next_entry,                 { desc = 'Bring the cursor to the next file entry' } },
            { 'n', '<DOWN>',    act.next_entry,                 { desc = 'Bring the cursor to the next file entry' } },
            { 'n', 'k',         act.prev_entry,                 { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<UP>',      act.prev_entry,                 { desc = 'Bring the cursor to the previous file entry.' } },
            { 'n', '<CR>',      act.select_entry,               { desc = 'Open the diff for the selected entry.' } },
            { 'n', '<C-b>',     act.scroll_view(-0.25),         { desc = 'Scroll the view up' } },
            { 'n', '<C-f>',     act.scroll_view(0.25),          { desc = 'Scroll the view down' } },
            { 'n', '<C-j>',     act.select_next_entry,          { desc = 'Open the diff for the next file' } },
            { 'n', '<C-k>',     act.select_prev_entry,          { desc = 'Open the diff for the previous file' } },
            { 'n', 'gf',        act.goto_file_edit,             { desc = 'Open the file in the previous tabpage' } },
            { 'n', 'gF',        act.goto_file_tab,              { desc = 'Open the file in a new tabpage' } },
            { 'n', '<Leader>e', act.focus_files,                { desc = 'Bring focus to the file panel' } },
            { 'n', '<Leader>b', act.toggle_files,               { desc = 'Toggle the file panel' } },
            { 'n', 'gx',        act.cycle_layout,               { desc = 'Cycle available layouts' } },
            { 'n', '?',         act.help('file_history_panel'), { desc = 'Open the help panel' } },
            { 'n', 'y', act.copy_hash,
              { desc = 'Copy the commit hash of the entry under the cursor', },
            },
          },
          option_panel = {
            { 'n', '<TAB>', act.select_entry,         { desc = 'Change the current option' } },
            { 'n', 'q',     act.close,                { desc = 'Close the panel' } },
            { 'n', '?',     act.help('option_panel'), { desc = 'Open the help panel' } },
          },
          help_panel = {
            { 'n', 'q',     act.close, { desc = 'Close help menu' } },
            { 'n', '<ESC>', act.close, { desc = 'Close help menu' } },
          },
        },
      })
    end
  },
}
