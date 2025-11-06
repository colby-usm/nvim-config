-- Dadbod and SQL autocompletion
return {
  {
    'tpope/vim-dadbod',
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'vim-dadbod' },
    config = function()
      -- UI options
      vim.g.dadbod_ui_auto_execute = 1
      vim.g.dadbod_ui_win_position = 'right'
      vim.g.dadbod_ui_max_height = 30

      -- Map <leader>db to toggle DBUI
      vim.keymap.set('n', '<leader>db', function()
        vim.cmd 'DBUIToggle'
      end, { desc = 'Toggle DBUI' })
    end,
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = { 'vim-dadbod', 'nvim-cmp' },
  },
}
