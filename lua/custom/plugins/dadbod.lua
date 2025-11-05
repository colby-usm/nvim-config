-- Dadbod and SQL autocompletion
return {
  {
    'tpope/vim-dadbod',
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'vim-dadbod' },
    config = function()
      -- You can configure UI options here if needed
      vim.g.dadbod_ui_auto_execute = 1
      vim.g.dadbod_ui_win_position = 'right'
      vim.g.dadbod_ui_max_height = 30
    end,
  },
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = { 'vim-dadbod', 'nvim-cmp' },
  },
}
