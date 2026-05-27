-- ~/.config/nvim/lua/custom/plugins/python.lua

local function resolve_python()
  local uv_venv = vim.fn.getcwd() .. '/.venv'
  if vim.fn.executable(uv_venv .. '/bin/python') == 1 then
    return uv_venv .. '/bin/python'
  end

  local conda = os.getenv 'CONDA_PREFIX'
  if conda and vim.fn.executable(conda .. '/bin/python') == 1 then
    return conda .. '/bin/python'
  end

  local venv = os.getenv 'VIRTUAL_ENV'
  if venv and vim.fn.executable(venv .. '/bin/python') == 1 then
    return venv .. '/bin/python'
  end

  local sys = vim.fn.exepath 'python3'
  return (sys ~= '' and sys) or 'python3'
end

local function resolve_ruff()
  local cwd = vim.fn.getcwd()
  local local_ruff = cwd .. '/.venv/bin/ruff'
  if vim.fn.executable(local_ruff) == 1 then
    return local_ruff
  end

  if vim.fn.executable('ruff') == 1 then
    return 'ruff'
  end

  return nil
end

local function add_python_paths()
  local python = resolve_python()

  local cmd = python
    .. [[ -c "import sysconfig;
paths=sysconfig.get_paths();
print(paths['stdlib']);
print(paths['purelib'])"]]

  local handle = io.popen(cmd)
  if not handle then
    return
  end

  local stdlib = handle:read '*l'
  local site = handle:read '*l'
  handle:close()

  local paths = { stdlib, site }

  for _, p in ipairs(paths) do
    if p and #p > 0 then
      vim.opt.path:append(p)
      vim.opt.path:append(p .. '/**')
    end
  end
end

return {
  {
    'neovim/nvim-lspconfig',
    ft = { 'python' },
    config = function()
      local python = resolve_python()

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = add_python_paths,
      })

      -- PYRIGHT
      vim.lsp.config('pyright', {
        settings = {
          python = {
            pythonPath = python,
            analysis = {
              typeCheckingMode = 'basic',
              diagnosticMode = 'openFilesOnly',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.enable('pyright')

      -- RUFF (FIXED)
      local ruff_cmd = resolve_ruff()
      if ruff_cmd then
        vim.lsp.config('ruff', {
          cmd = { ruff_cmd, 'server' },
          filetypes = { 'python' },
          root_dir = vim.fs.root(0, { 'pyproject.toml', '.git' }) or vim.fn.getcwd(),
        })

        vim.lsp.enable('ruff')
      end
    end,
  },
}
