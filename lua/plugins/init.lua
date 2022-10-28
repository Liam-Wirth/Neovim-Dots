return require'packer'.startup(function(use)
    --Packer
    use 'wbthomason/packer.nvim'
    --Nvim-Tree
    use 'nvim-tree/nvim-web-devicons' -- optional, for file icons
    use 'nvim-tree/nvim-tree.lua'

    --telescope
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-lua/plenary.nvim'
    --themes
    use 'EdenEast/nightfox.nvim'
    use 'folke/tokyonight.nvim'
    --bufferline
    use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}
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
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }            -- Add git related info in the signs columns and popups
    use 'numToStr/Comment.nvim'                                                          -- "gc" to comment visual regions/lines

    use 'tpope/vim-sleuth'
    use 'lukas-reineke/indent-blankline.nvim'                                            -- Add indentation guides even on blank lines

    -------SNIPPETS?
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin
    use "rafamadriz/friendly-snippets" --more snippets?


 end)
