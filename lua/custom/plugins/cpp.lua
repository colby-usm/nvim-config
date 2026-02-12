return {
  {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp', 'objc', 'objcpp' },
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      --------------------
      -- LSP (clangd)
      --------------------
      vim.lsp.config.clangd = {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--completion-style=detailed',
          '--header-insertion=iwyu',
          '--pch-storage=memory',
        },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        root_markers = {
          'compile_commands.json',
          'compile_flags.txt',
          '.git',
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'c', 'cpp', 'objc', 'objcpp' },
        callback = function()
          vim.lsp.start(vim.lsp.config.clangd)
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end,
      })

      --------------------
      -- DAP (Debugging)
      --------------------
      local dap = require 'dap'
      local dapui = require 'dapui'

      dapui.setup()

      -- LLDB adapter (macOS)
      dap.adapters.lldb = {
        type = 'executable',
        command = '/Users/colby/tools/codelldb/extension/adapter/codelldb',
        name = 'lldb',
      }

      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'lldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/a.out', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cpp',
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts)
          vim.keymap.set('n', '<F5>', dap.continue, opts)
          vim.keymap.set('n', '<F10>', dap.step_over, opts)
          vim.keymap.set('n', '<F11>', dap.step_into, opts)
          vim.keymap.set('n', '<F12>', dap.step_out, opts)
          vim.keymap.set('n', '<leader>dx', dap.terminate, opts)
          vim.keymap.set('n', '<leader>du', dapui.toggle, opts)
        end,
      })

      --------------------
      --------------------
      -- Compile / Build
      --------------------
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'cpp',
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          local function term(cmd)
            vim.cmd 'split'
            vim.cmd('terminal ' .. cmd)
          end

          -- Debug build
          vim.keymap.set('n', '<leader>cc', function()
            local file = vim.fn.expand '%:p'
            local out = vim.fn.expand '%:p:h' .. '/a.out'
            term('clang++ -std=c++20 -O0 -g ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(out))
          end, opts)

          -- Optimized build
          vim.keymap.set('n', '<leader>co', function()
            local file = vim.fn.expand '%:p'
            local out = vim.fn.expand '%:p:h' .. '/a.out'
            term('clang++ -std=c++20 -O3 -march=native ' .. vim.fn.shellescape(file) .. ' -o ' .. vim.fn.shellescape(out))
          end, opts)

          -- Run
          vim.keymap.set('n', '<leader>rr', function()
            local out = vim.fn.expand '%:p:h' .. '/a.out'
            term(vim.fn.shellescape(out))
          end, opts)

          -- CMake build
          vim.keymap.set('n', '<leader>cb', function()
            term 'cmake -S . -B build && cmake --build build -j'
          end, opts)

          -- Clean
          vim.keymap.set('n', '<leader>cl', function()
            term 'rm -rf build'
          end, opts)
        end,
      })
    end,
  },
}
