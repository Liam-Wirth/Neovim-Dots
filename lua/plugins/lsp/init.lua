ret = {
  ---  --  {
  --  'utilyre/barbecue.nvim',
  --  lazy = true,
  --  event = "BufReadPost",
  --  name = 'barbecue',
  --  version = '*',
  --  dependencies = {
  --    'SmiteshP/nvim-navic',
  --    'nvim-tree/nvim-web-devicons',
  --  },
  --  opts = {},
 --},
{   "hrsh7th/cmp-nvim-lsp" },
{
      "folke/neodev.nvim",
      opts = {
        debug = true,
        experimental = {
          pathStrict = true,
        },
      },
    },
    'p00f/clangd_extensions.nvim',
    "neovim/nvim-lspconfig",
   'jose-elias-alvarez/null-ls.nvim',
   {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
    },
    cmd = { 'AerialOpen', 'AerialToggle' },
  },
  {
     'simrat39/rust-tools.nvim',
     lazy = true,
     event = "BufReadPost",
  }
    }
  
  vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.format({ async = true })
   end
   )
return ret
