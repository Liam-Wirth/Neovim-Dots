require('settings')




require('plugins')
    require('plugins.nvim-tree-config')
    require('plugins.bufferline')
    require('plugins.lualine')
--require('colorschemes-config.tokyonight')
    require('plugins.discordrpc')





require('plugins.treesitter')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.lsp-config')
        require('lsp-config.null-ls')
        require('lsp-config.nvim-cmp')
        require('lsp-config.luasnip')

