-- ~/.config/nvim/lua/custom/plugins/python.lua

-- 🔧 Python resolver (conda > venv > .venv > system)
local function resolve_python()
  -- 1️⃣ Conda
  local conda = os.getenv('CONDA_PREFIX')
  if conda and vim.fn.executable(conda .. '/bin/python') == 1 then
    return conda .. '/bin/python'
  end

  -- 2️⃣ Active venv
  local venv = os.getenv('VIRTUAL_ENV')
  if venv and vim.fn.executable(venv .. '/bin/python') == 1 then
    return venv .. '/bin/python'
  end

  -- 2️⃣b Local .venv
  local cwd = vim.fn.getcwd()
  local handle = io.popen('find "' .. cwd .. '" -type d -name ".venv" -print -quit')
  if handle then
    local result = handle:read('*l')
    handle:close()
    if result and vim.fn.executable(result .. '/bin/python') == 1 then
      return result .. '/bin/python'
    end
  end

  -- 3️⃣ System fallback
  return vim.fn.exepath('python3') or 'python3'
end

-- 📦 Add site-packages to 'path' so gf works
local function add_python_paths()
  local python = resolve_python()

  local cmd = python .. [[ -c "import sysconfig; print(sysconfig.get_paths()['purelib'])"]]
  local handle = io.popen(cmd)
  if not handle then return end

  local site = handle:read('*l')
  handle:close()

  if site and #site > 0 then
    vim.opt.path:append(site)
    vim.opt.path:append(site .. '/**')
  end
end

return {

  -- 1️⃣ Python LSP (Pyright)
  {
    'neovim/nvim-lspconfig',
    ft = { 'python' },
    config = function()
      local python = resolve_python()

      -- ensure gf works for site-packages
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          add_python_paths()
        end,
      })

      vim.lsp.config('pyright', {
        settings = {
          python = {
            pythonPath = python,
            analysis = {
              typeCheckingMode = 'off',
              diagnosticMode = 'openFilesOnly',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
        on_attach = function(_, buf)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = buf, desc = 'Go to definition' })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = buf, desc = 'Go to references' })
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = 'Hover docs' })
        end,
      })

      vim.lsp.enable('pyright')
    end,
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

      local python_path = resolve_python()
      local cwd = vim.fn.getcwd()

      local function resolve_debugpy_python()
        local python = resolve_python()
      
        -- check if debugpy exists in this interpreter
        local check = python .. [[ -c "import debugpy" 2>/dev/null]]
        local ok = os.execute(check)
      
        if ok == true or ok == 0 then
          return python
        end
      
        -- fallback (global python where debugpy is installed)
        return vim.fn.exepath('python3')
      end
      
      dap_python.setup(resolve_debugpy_python())


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

  -- 3️⃣ Python run helpers
  {
    'nvim-lua/plenary.nvim',
    ft = { 'python' },
    config = function()
      vim.keymap.set('n', '<leader>pr', function()
        local file = vim.fn.expand '%:p'
        local cwd = vim.fn.getcwd()
        local python = resolve_python()

        vim.cmd('split | terminal PYTHONPATH=' .. cwd .. ' ' .. python .. ' ' .. file)
        vim.cmd 'stopinsert'
      end, { desc = 'Run current Python file' })

      vim.keymap.set('n', '<leader>pm', function()
        local file = vim.fn.expand '%:p'
        local cwd = vim.fn.getcwd()
        local python = resolve_python()

        local rel = vim.fn.fnamemodify(file, ':~:.')
        local module = rel:gsub('/', '.'):gsub('%.py$', '')

        vim.cmd('split | terminal cd ' .. cwd .. ' && ' .. python .. ' -m ' .. module)
        vim.cmd 'stopinsert'
      end, { desc = 'Run Python file as module' })
    end,
  },
}
