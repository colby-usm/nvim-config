return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    -- Keymaps for Harpoon
    -- Add a file to Harpoon
    vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Add file to Harpoon' })
    -- Toggle Harpoon menu
    vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
    -- Go to Harpoon files 1-7
    vim.keymap.set('n', '<leader>1', function()
      ui.nav_file(1)
    end, { desc = 'Harpoon file 1' })
    vim.keymap.set('n', '<leader>2', function()
      ui.nav_file(2)
    end, { desc = 'Harpoon file 2' })
    vim.keymap.set('n', '<leader>3', function()
      ui.nav_file(3)
    end, { desc = 'Harpoon file 3' })
    vim.keymap.set('n', '<leader>4', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon file 4' })
    vim.keymap.set('n', '<leader>5', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon file 5' })
    vim.keymap.set('n', '<leader>6', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon file 6' })
    vim.keymap.set('n', '<leader>7', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon file 7' })
    vim.keymap.set('n', '<leader>8', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon file 8' })
  end,
}
