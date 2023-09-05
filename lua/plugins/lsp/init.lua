local ret = {
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
    {
    "neovim/nvim-lspconfig",
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      require("plugins.lsp.lspconf")
    end,
  },

  -- 'jose-elias-alvarez/null-ls.nvim',
   {
    'stevearc/aerial.nvim',
    opts = {
      backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      on_attach = function(bufnr)
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,
        default_direction = "prefer_left",
    },
    cmd = { 'AerialOpen', 'AerialToggle' },
  },
  {
     'simrat39/rust-tools.nvim',
     lazy = true,
     event = "BufReadPost",
     config = function()
	require('rust-tools').setup({
	   server = {
	      on_attach = function(_, bufnr)
               -- Hover actions
	      -- vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
	       -- Code action groups
	       --vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
	     end,
	   }
	})
     end,
  }
 }
 return ret
