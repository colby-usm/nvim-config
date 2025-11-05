return {
  {
    'mfussenegger/nvim-lint',
    config = function()
      local lint = require 'lint'

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function()
          local venv = os.getenv 'VIRTUAL_ENV'
          local pylint_path = venv and (venv .. '/bin/pylint') or 'pylint'

          lint.linters.pylint.cmd = pylint_path
          lint.linters.pylint.args = {
            '--init-hook',
            -- Add src folder to sys.path so imports like `from src.utils...` resolve
            [[import sys, os; sys.path.insert(0, os.path.abspath(os.path.join(os.getcwd(), "src")))]],
          }
        end,
      })
    end,
  },
}
