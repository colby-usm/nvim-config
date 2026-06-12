vim.o.number = true -- Make line numbers default
vim.o.mouse = 'a' -- Mouse mode
vim.o.showmode = false -- Don't show the mode, since it's already in the status line

-- Sync clipboard between OS and Neovim ; See ':help clipboard'
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true -- See `:help 'list' and `:help 'listchars'`
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.o.inccommand = 'split' -- Preview substitutions live, as you type!
vim.o.cursorline = true -- Show which line your cursor is on
vim.o.scrolloff = 5 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.confirm = true -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
