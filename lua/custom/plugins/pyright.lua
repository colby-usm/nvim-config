return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              -- Use the current venv if active
              pythonPath = os.getenv 'VIRTUAL_ENV' and (os.getenv 'VIRTUAL_ENV' .. '/bin/python') or 'python3',
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
}
