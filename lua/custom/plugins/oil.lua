-- ~/.config/nvim/lua/custom/plugins/oil.lua
return {
  {
    'stevearc/oil.nvim',
    keys = { { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' } },
    config = function()
      local oil = require 'oil'
      oil.setup {
        default_file_explorer = true,
        columns = { 'icon' },
        buf_options = { buflisted = false, bufhidden = 'hide' },
        win_options = { wrap = false, signcolumn = 'no', cursorcolumn = false, foldcolumn = '0' },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        lsp_file_methods = { enabled = true, timeout_ms = 1000, autosave_changes = false },
        constrain_cursor = 'editable',
        watch_for_changes = false,
        keymaps = {
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
          ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
          ['<C-t>'] = { 'actions.select', opts = { tab = true } },
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = { 'actions.close', mode = 'n' },
          ['<C-l>'] = { 'actions.refresh', mode = 'n' },
          ['-'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name)
            return name:match '^%.'
          end,
        },
      }
    end,
  },
}
