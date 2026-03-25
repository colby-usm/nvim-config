-- ~/.config/nvim/lua/custom/plugins/python.lua
return {
  -- 1️⃣ Python LSP (Pyright)
  {
    'neovim/nvim-lspconfig',
    ft = { 'python' }, -- only load for Python files
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              pythonPath = (os.getenv 'VIRTUAL_ENV' and (os.getenv 'VIRTUAL_ENV' .. '/bin/python')) or 'python3',
              analysis = {
                typeCheckingMode = 'off',
                diagnosticMode = 'openFilesOnly',
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },

  -- 2️⃣ Python DAP
  {
    'mfussenegger/nvim-dap-python',
    ft = { 'python' },
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'
      local dapui = require 'dapui'

      -- Automatically find a virtual environment
      local function find_venv(start_path)
        local handle = io.popen('find "' .. start_path .. '" -type d -name ".venv" -print -quit')
        if handle then
          local result = handle:read '*l'
          handle:close()
          return result
        end
      end

      local cwd = vim.fn.getcwd()
      local venv_path = find_venv(cwd) or os.getenv 'VIRTUAL_ENV'
      local python_path = venv_path and (venv_path .. '/bin/python') or 'python3'

      dap_python.setup(python_path)

      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            return python_path
          end,
          cwd = cwd,
          console = 'internalConsole',
          stopOnEntry = false,
          justMyCode = true,
          showReturnValue = true,
          env = { PYTHONPATH = cwd },
        },
      }

      dap.defaults.fallback.exception_breakpoints = { 'raised', 'uncaught' }

      -- Auto-open DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },

  -- 3️⃣ Python run helpers (keymaps)
  {
    'nvim-lua/plenary.nvim',
    ft = { 'python' },
    config = function()
      vim.keymap.set('n', '<leader>pr', function()
        local file = vim.fn.expand '%:p'
        local cwd = vim.fn.getcwd()
        vim.cmd('split | terminal PYTHONPATH=' .. cwd .. ' python3 ' .. file)
        vim.cmd 'stopinsert'
      end, { desc = 'Run current Python file' })

      vim.keymap.set('n', '<leader>pm', function()
        local file = vim.fn.expand '%:p'
        local cwd = vim.fn.getcwd()
        local rel = vim.fn.fnamemodify(file, ':~:.')
        local module = rel:gsub('/', '.'):gsub('%.py$', '')
        vim.cmd('split | terminal cd ' .. cwd .. ' && python3 -m ' .. module)
        vim.cmd 'stopinsert'
      end, { desc = 'Run Python file as module' })
    end,
  },
}
