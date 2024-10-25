
   return {
      {
      'nvimdev/lspsaga.nvim',
      lazy = true,
      event = "LspAttach",
      config = function()
         require('lspsaga').setup({})
      end,
      dependencies = {
         'nvim-treesitter/nvim-treesitter',    -- optional
         'nvim-tree/nvim-web-devicons',        -- optional
      }
      }
   }
