--War

return require'packer'.startup(function()
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
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

end)
