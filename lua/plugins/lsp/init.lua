local ret = {
   {
      'utilyre/barbecue.nvim',
      lazy = true,
      event = "BufReadPost",
      name = 'barbecue',
      version = '*',
      dependencies = {
         'SmiteshP/nvim-navic',
         'nvim-tree/nvim-web-devicons',
      },
      opts = {},
   },
   { "hrsh7th/cmp-nvim-lsp" },
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
      end,
   },
   {
      -- lsp_signature | shows the signature of a function when typing parameters
      'ray-x/lsp_signature.nvim',
      lazy = true,
      event = "BufReadPost",
      config = function()
         require('lsp_signature').setup({
            floating_window = false
         })
      end
   },
   {
      "monaqa/dial.nvim",
      lazy = true,
      event = { "BufreadPost", "BufreadPre" },
      config = function()
         local augend = require("dial.augend")
         require("dial.config").augends:register_group {
            default = {
               augend.constant.new{
                  elements = { "and", "or" },
                  word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                  cyclic = true, -- "or" is incremented into "and".
               },
               augend.constant.new{
                  elements = { "&&", "||" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new{
                  elements = { "++", "--" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new{
                  elements = { "+=", "-=" },
                  word = false,
                  cyclic = true,
               },
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.date.alias["%Y/%m/%d"],
               augend.constant.alias.bool,
            },
            typescript = {
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.constant.new { elements = { "let", "const" } },
            },
            visual = {
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.date.alias["%Y/%m/%d"],
               augend.constant.alias.alpha,
               augend.constant.alias.Alpha,
            },
         }
      end
   }
}
return ret
