local vim = vim;
--TODO Move all configs to their own respective files
return require'packer'.startup(function(use)
    --Packer
    use 'wbthomason/packer.nvim'
    --Nvim-Tree
    use 'nvim-tree/nvim-web-devicons' -- optional, for file icons
    use 'nvim-tree/nvim-tree.lua'

    --telescope
    use 'nvim-telescope/telescope.nvim'
    --bufferline
    use {'akinsho/bufferline.nvim', tag = "v3.*"}
    --autopairs
    use {
	    "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    --lualine
    use 'nvim-lualine/lualine.nvim'
    --notify
    use 'rcarriga/nvim-notify'
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
--    use 'numToStr/Comment.nvim'                                                          -- "gc" to comment visual regions/lines
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
    
    use {
    'goolord/alpha-nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function ()
        require'alpha'.setup(require'alpha.themes.startify'.config)
    end
    }
  --TODO fix dis?

    -- Debugging
    use 'nvim-lua/plenary.nvim'
    use "folke/todo-comments.nvim"
    require'plugins.todo-comments'
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
require("luasnip.loaders.from_vscode").lazy_load()





  -- Lua

use 'karb94/neoscroll.nvim'
use 'andweeb/presence.nvim'
use 'folke/which-key.nvim'
  require('plugins.whichkey')




  use 'NTBBloodbath/doom-one.nvim'
    use {
    'lervag/vimtex',
    opt = true,
    config = function ()
        vim.g.vimtex_view_general_viewer = 'okular'
        vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
	vim.g.vimtex_compiler_method = 'latexrun'
	vim.g.vimtex_view_method = 'okular'
    end,
    ft = 'tex'
}
  use 'mhinz/neovim-remote'
end )
