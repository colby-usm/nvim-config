-- plugins/cmp.lua
return {
  {
    'hrsh7th/nvim-cmp', -- Completion engine
    dependencies = {
      'hrsh7th/cmp-buffer', -- buffer completions
      'hrsh7th/cmp-path', -- path completions
      'hrsh7th/cmp-nvim-lsp', -- LSP completions
      'saadparwaiz1/cmp_luasnip', -- snippet completions
      'L3MON4D3/LuaSnip', -- snippet engine
    },
  },
}
