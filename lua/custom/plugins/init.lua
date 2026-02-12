-- lua/cutstom/plugins/init.lua
-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

require 'custom.plugins.java'
require 'custom.plugins.oil'
-- ─────────────────────────────────────────────
-- Python run helpers
-- ─────────────────────────────────────────────

-- Run current Python file directly (like `python3 file.py`)
vim.keymap.set('n', '<leader>pr', function()
  if vim.bo.filetype == 'python' then
    local file = vim.fn.expand '%:p' -- full path to current file
    local cwd = vim.fn.getcwd() -- current working directory
    vim.cmd('split | terminal PYTHONPATH=' .. cwd .. ' python3 ' .. file)
    vim.cmd 'stopinsert'
  end
end, { desc = 'Run current Python file directly' })

-- Run current Python file as a module (like `python3 -m package.module`)
vim.keymap.set('n', '<leader>pm', function()
  if vim.bo.filetype == 'python' then
    vim.cmd 'write'
    local file = vim.fn.expand '%:p'
    local cwd = vim.fn.getcwd()
    local rel = vim.fn.fnamemodify(file, ':~:.') -- relative to CWD
    local module = rel:gsub('/', '.'):gsub('%.py$', '')
    vim.cmd('split | terminal cd ' .. cwd .. ' && python3 -m ' .. module)
    vim.cmd 'stopinsert'
  end
end, { desc = 'Save and run current Python file as module' })

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

-- Run current Julia file
vim.keymap.set('n', '<leader>jm', function()
  if vim.bo.filetype == 'julia' then
    vim.cmd 'write'
    local file = vim.fn.expand '%:p'
    local cwd = vim.fn.getcwd()
    local rel = vim.fn.fnamemodify(file, ':~:.') -- relative to CWD
    vim.cmd('split | terminal cd ' .. cwd .. ' && julia ' .. rel)
    vim.cmd 'stopinsert'
  end
end, { desc = 'Save and run current Julia file' })

vim.env.PATH = vim.env.PATH .. ':/usr/local/mysql-9.5.0-macos15-arm64/bin'
return {}
