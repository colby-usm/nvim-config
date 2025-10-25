return {
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  tag = 'v2.16',
  init = function()
    -- PDF viewer (adjust for your system)
    vim.g.vimtex_view_method = 'skim'

    -- Compiler method
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = '', -- optional build directory
      callback = 1,
      continuous = 1, -- auto compile on save
      executable = 'latexmk',
      options = {
        '-pdf',
        '-interaction=nonstopmode',
        '-synctex=1',
      },
    }

    -- Optional: fold sections, environments, comments
    vim.g.vimtex_fold_enabled = 1

    -- Optional: auto spell check in LaTeX
    vim.cmd [[autocmd FileType tex setlocal spell]]
  end,
}
