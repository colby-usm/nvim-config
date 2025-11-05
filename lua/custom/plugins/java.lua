return {
  {
    'nvim-java/nvim-java',
    ft = 'java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require('java').setup()

      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Setup DAP UI
      dapui.setup()

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Setup LSP
      require('lspconfig').jdtls.setup {
        on_attach = function(client, bufnr)
          vim.diagnostic.config {
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            underline = true,
          }
        end,
      }

      -- Set up keymaps for Java files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          -- Use Java 22 explicitly
          local java_home = '/Library/Java/JavaVirtualMachines/jdk-22.jdk/Contents/Home'
          local javac = java_home .. '/bin/javac'
          local java = java_home .. '/bin/java'

          -- Run
          vim.keymap.set('n', '<leader>rr', function()
            local file = vim.fn.expand '%:p'
            local class = vim.fn.expand '%:t:r'
            local dir = vim.fn.expand '%:p:h'

            vim.cmd 'split'
            vim.cmd('terminal cd ' .. vim.fn.shellescape(dir) .. ' && ' .. javac .. ' ' .. vim.fn.shellescape(file) .. ' && ' .. java .. ' ' .. class)
          end, opts)

          -- Debug keymaps (using F-keys to avoid conflicts)
          vim.keymap.set('n', '<F9>', dap.toggle_breakpoint, opts) -- Toggle breakpoint
          vim.keymap.set('n', '<F5>', dap.continue, opts) -- Start/Continue
          vim.keymap.set('n', '<F10>', dap.step_over, opts) -- Step over
          vim.keymap.set('n', '<F11>', dap.step_into, opts) -- Step into
          vim.keymap.set('n', '<F12>', dap.step_out, opts) -- Step out
          vim.keymap.set('n', '<leader>dx', dap.terminate, opts) -- Stop debugging
          vim.keymap.set('n', '<leader>du', dapui.toggle, opts) -- Toggle UI

          -- LSP actions
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
}
