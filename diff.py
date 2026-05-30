diff --git a/init.lua b/init.lua
index ddba936..2b4a886 100644
--- a/init.lua
+++ b/init.lua
@@ -679,7 +679,14 @@ require('lazy').setup({
         -- clangd = {},
         -- gopls = {},
         -- pyright = {},
-        -- ruff = {},
+        ruff = {},
+        basedpyright = {
+          settings = {
+            python = {
+              pythonPath = vim.fn.getcwd() .. '/.venv/bin/python',
+            },
+          },
+        },
         -- rust_analyzer = {},
         -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
         --
@@ -719,26 +726,26 @@ require('lazy').setup({
       --
       -- You can add other tools here that you want Mason to install
       -- for you, so that they are available from within Neovim.
-      local ensure_installed = vim.tbl_keys(servers or {})
-      vim.list_extend(ensure_installed, {
-        'stylua', -- Used to format Lua code
-      })
+      local ensure_installed = { 'stylua', 'clangd', 'lua_ls' } -- only Mason-managed tools
       require('mason-tool-installer').setup { ensure_installed = ensure_installed }
-
       require('mason-lspconfig').setup {
-        ensure_installed = { 'pyright', 'lua_ls', 'clangd' },
-        automatic_installation = true,
+        ensure_installed = { 'lua_ls', 'clangd' },
+        automatic_installation = false,
         handlers = {
           function(server_name)
             local server = servers[server_name] or {}
-            -- This handles overriding only values explicitly passed
-            -- by the server configuration above. Useful when disabling
-            -- certain features of an LSP (for example, turning off formatting for ts_ls)
             server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
             require('lspconfig')[server_name].setup(server)
           end,
         },
       }
+      -- Setup UV-managed LSPs manually
+      for _, name in ipairs { 'basedpyright', 'ruff' } do
+        local server = servers[name] or {}
+        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
+        vim.lsp.config(name, server)
+        vim.lsp.enable(name)
+      end
     end,
   },
 
diff --git a/lua/kickstart/plugins/debug.lua b/lua/kickstart/plugins/debug.lua
index 7e2b920..8b0bb94 100644
--- a/lua/kickstart/plugins/debug.lua
+++ b/lua/kickstart/plugins/debug.lua
@@ -158,10 +158,17 @@ return {
         name = 'Launch file',
         program = '${file}',
         pythonPath = function()
-          local venv = os.getenv 'VIRTUAL_ENV'
-          if venv then
+          -- Check for uv's .venv in project root
+          local venv = vim.fn.getcwd() .. '/.venv'
+          if vim.fn.isdirectory(venv) == 1 then
             return venv .. '/bin/python'
           end
+          -- Fall back to VIRTUAL_ENV env var
+          local env_venv = os.getenv 'VIRTUAL_ENV'
+          if env_venv then
+            return env_venv .. '/bin/python'
+          end
+          -- Last resort
           return 'python3'
         end,
       },
diff --git a/lua/kickstart/plugins/lint.lua b/lua/kickstart/plugins/lint.lua
index e7c2488..c6cfd97 100644
--- a/lua/kickstart/plugins/lint.lua
+++ b/lua/kickstart/plugins/lint.lua
@@ -3,11 +3,14 @@ return {
     'mfussenegger/nvim-lint',
     event = { 'BufReadPre', 'BufNewFile' },
     config = function()
-      local lint = require('lint')
+      local lint = require 'lint'
 
       lint.linters_by_ft = {
         python = { 'ruff' },
       }
+      -- Tell ruff to use the project venv
+      lint.linters.ruff.cmd = 'uv'
+      lint.linters.ruff.prepend_args = { 'run', 'ruff' }
 
       local augroup = vim.api.nvim_create_augroup('lint', { clear = true })
 
