local vim = vim;
--TODO: Move all configs to their own respective files
return require'packer'.startup(function(use)
--------------------------------------------------------
---                   Meta shit                       --
--------------------------------------------------------
  use({
    'lewis6991/impatient.nvim', -- Decrease nvim load times
    config = function()
      require('impatient')
    end,
  })

  use('dstein64/vim-startuptime') -- Measure startup time

  use('nvim-lua/popup.nvim') -- Pop up helper

  use('nvim-lua/plenary.nvim') -- Neovim Lua functions
    --Packer
  use 'wbthomason/packer.nvim'
--------------------------------------------------------
---                   UI Stuff                        --
--------------------------------------------------------
    --Nvim-Tree
  use({
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
      'nvim-tree/nvim-tree.lua',
      config = function ()
          require('plugins.lookandfeel.nvimtree')
      end,
    })

    --telescope
    use 'nvim-telescope/telescope.nvim'
    --bufferline
  use {'akinsho/bufferline.nvim', tag = "v3.*",
        config = function ()
          require('plugins.lookandfeel.bufferline')
        end,
      }
    --lualine  -- Fancy status line/tab line
use({
    'nvim-lualine/lualine.nvim',
    config = function()
      require('plugins.lookandfeel.lualine')
    end,
  })
  --notify
use {
    'rcarriga/nvim-notify',
    config = function()
      require('plugins.lookandfeel.notify')
    end,
  }
 use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require('plugins.lookandfeel.alpha')
    end
    }
 use {
    'wfxr/minimap.vim',
 }

use({
    "nvim-treesitter/nvim-treesitter-context", -- Show current context via TreeSitter
    config = function()
      require('treesitter-context').setup({
        pattern = {
          tex = {
            'minted_environment',
          },
        },
      })
    end,
  })
--TODO: get the colors to work more accurately with my config? like it would be nice for shit to kinda just line up ya know
use({
    'p00f/nvim-ts-rainbow', -- Rainbow parenthesis from TreeSitter
    config = function()
      require('nvim-treesitter.configs').setup({
        rainbow = {
          enable = false,
          extended_mode = false, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil, -- Do not enable for files with more than n lines, int
        },
      })
    end,
    after = "nvim-treesitter",
  })
--------------------------------------------------------
---                   Text Stuff?                     --
--------------------------------------------------------
 --Highlights the word under the cursor similar to how other editors will
use {
  'RRethy/vim-illuminate',
  config =function ()
    require('plugins.illuminate')
  end
}
use({
    'folke/todo-comments.nvim', -- Todo comment highlighting
    config = function()
      require('todo-comments').setup {
          require('plugins.lookandfeel.todocomments')
      }
    end,
  })
use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
}










  -------------------------------------------------------
  --                     Formatting                    --
  -------------------------------------------------------
  --TODO: look into the configuration for this plugin because I kinda just stole this from someone elses cfg
  use({
    "mhartington/formatter.nvim", -- auto reformatter
    config = function()
      require("formatter").setup({
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua,
          },

          rust = {
            require("formatter.filetypes.rust").rustfmt,
          },

          go = {
            require("formatter.filetypes.go").gofmt,
          },

          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      })
    end,
  })

  use('junegunn/vim-easy-align') -- Quickly align around a character















--lsp-config,mason,dap,linter,and formatters
    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'mfussenegger/nvim-dap'
    use 'jose-elias-alvarez/null-ls.nvim'
   use 'nvim-treesitter/nvim-treesitter'                                                -- Highlight, edit, and navigate code
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = { 'nvim-treesitter' } } -- Additional textobjects for treesitter
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'tpope/vim-fugitive'                                                             -- Git commands in nvim
    use 'tpope/vim-rhubarb'                                                              -- Fugitive-companion to interact with github
    use 'lewis6991/gitsigns.nvim'
    use 'mfussenegger/nvim-jdtls'
    use 'tpope/vim-sleuth'
    use 'lukas-reineke/indent-blankline.nvim'


    -------SNIPPETS?
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use "rafamadriz/friendly-snippets" --more snippets?
-- don't pass any arguments, luasnip will find the collection because it is
-- (probably) in rtp.
-- specify the full path...
-- or relative to the directory of $MYVIMRC
require("luasnip.loaders.from_vscode").load()
require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/lua/lspconfig/snippets/"})
    -- Debugging
use {
  "folke/trouble.nvim",
  requires = "kyazdani42/nvim-web-devicons",
  config = function()
    require("trouble").setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end
  }
use "NvChad/nvim-colorizer.lua"

use 'andweeb/presence.nvim'
use 'folke/which-key.nvim'
  require('plugins.whichkey')




  use 'NTBBloodbath/doom-one.nvim'
  use 'mhinz/neovim-remote'

  -------------------------------------------------------
  --               Misc/Unsorted Plugins               --
  -------------------------------------------------------

 -- use({
 --   "iamcco/markdown-preview.nvim", -- Live markdown preview
 --   setup = function()
 --     vim.g.mkdp_filetypes = { "markdown" }
 --   end,
 --   ft = { "markdown" },
 --   run = "cd app && npm install",
 -- })
end )
