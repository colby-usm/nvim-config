return {
  {
    'MeanderingProgrammer/harpoon-core.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    build = function()
      local file = vim.fn.stdpath 'data' .. '/lazy/harpoon-core.nvim/lua/harpoon-core/ui.lua'
      local content = table.concat(vim.fn.readfile(file), '\n')
      content = content:gsub("vim.api.nvim_create_autocmd%('BufModifiedSet'", "vim.api.nvim_create_autocmd('OptionSet', { pattern = 'modified' } --[[")
      vim.fn.writefile(vim.split(content, '\n'), file)
    end,
    config = function()
      local harpoon = require 'harpoon-core'
      harpoon.setup()

      vim.keymap.set('n', '<leader>a', harpoon.add_file, { desc = 'Add file to Harpoon' })
      vim.keymap.set('n', '<leader>h', harpoon.toggle_quick_menu, { desc = 'Toggle Harpoon menu' })
      vim.keymap.set('n', '<leader>1', function()
        harpoon.nav_file(1)
      end, { desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<leader>2', function()
        harpoon.nav_file(2)
      end, { desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<leader>3', function()
        harpoon.nav_file(3)
      end, { desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<leader>4', function()
        harpoon.nav_file(4)
      end, { desc = 'Harpoon file 4' })
      vim.keymap.set('n', '<leader>5', function()
        harpoon.nav_file(5)
      end, { desc = 'Harpoon file 5' })
      vim.keymap.set('n', '<leader>6', function()
        harpoon.nav_file(6)
      end, { desc = 'Harpoon file 6' })
      vim.keymap.set('n', '<leader>7', function()
        harpoon.nav_file(7)
      end, { desc = 'Harpoon file 7' })
      vim.keymap.set('n', '<leader>8', function()
        harpoon.nav_file(8)
      end, { desc = 'Harpoon file 8' })
    end,
  },
}
