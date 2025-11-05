-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require 'custom.plugins.java'

-- Keymap: Run current Python file in a split terminal
vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand '%'
  if vim.bo.filetype == 'python' then
    vim.cmd('split | terminal python3 ' .. file)
    vim.cmd 'stopinsert'
  end
end, { desc = 'Run current Python file' })

vim.api.nvim_create_user_command('Pylint', function()
  local lint = require 'lint'
  print('Python linter cmd:', lint.linters.pylint.cmd)
end, {})

vim.keymap.set('n', '<leader>dq', function()
  local dap = require 'dap'
  local dapui = require 'dapui'
  dap.terminate { terminateAll = true } -- stop all active debug sessions
  dapui.close() -- close UI panels
end, { desc = 'DAP: Terminate session and close UI' })

return {}
