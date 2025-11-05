return {
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'

      -- Automatically locate .venv folder starting from current working directory
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

      -- Define Python debug configuration
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          pythonPath = function()
            return python_path
          end,
          cwd = vim.fn.getcwd(),
          console = 'internalConsole',
          stopOnEntry = false,
          justMyCode = true,
          showReturnValue = true,
          -- Add src directory to PYTHONPATH
          env = {
            PYTHONPATH = vim.fn.getcwd(),
          },
        },
      }

      -- Set exception breakpoints to pause on raised exceptions
      dap.defaults.fallback.exception_breakpoints = { 'raised', 'uncaught' }

      -- Setup dap-ui listeners
      local dapui = require 'dapui'
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        -- Don't auto-close so you can see the error
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        -- Don't auto-close so you can see the error
      end

      print('Python DAP ready (using: ' .. python_path .. ')')
    end,
  },
}
