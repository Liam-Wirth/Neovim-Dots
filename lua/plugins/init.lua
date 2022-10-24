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
    

end)
