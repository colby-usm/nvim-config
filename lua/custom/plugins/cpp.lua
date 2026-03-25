-- ~/.config/nvim/lua/custom/plugins/cpp.lua
return {
  -- Treesitter (dependency)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    ft = { 'c', 'cpp', 'lua' }, -- load only for these filetypes
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'cpp', 'c', 'lua' },
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },

  -- LSP for C/C++
  {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- ensures Treesitter is loaded first
    opts = {
      servers = {
        clangd = {},
      },
    },
  },

  -- DAP for C/C++
  {
    'mfussenegger/nvim-dap',
    ft = { 'c', 'cpp' },
    config = function()
      local dap = require 'dap'
      dap.adapters.cppdbg = {
        type = 'executable',
        command = '/opt/homebrew/opt/llvm/bin/lldb-dap',
        name = 'lldb',
      }
      dap.configurations.cpp = {
        {
          name = 'Launch file',
          type = 'cppdbg',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
        },
      }
      dap.configurations.c = dap.configurations.cpp

      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', '<F5>', dap.continue, opts)
      vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts)
      vim.keymap.set('n', '<F10>', dap.step_over, opts)
      vim.keymap.set('n', '<F11>', dap.step_into, opts)
      vim.keymap.set('n', '<F12>', dap.step_out, opts)
      vim.keymap.set('n', '<leader>dx', dap.terminate, opts)
    end,
  },

  -- DAP UI
  {
    'rcarriga/nvim-dap-ui',
    ft = { 'c', 'cpp' },
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()
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
}
