require('settings')
require('plugins')
    require('plugins.nvim-tree-config')
    require('plugins.bufferline')
    require('plugins.lualine')
    require('lsp-config')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.null-ls')
        require('lsp-config.nvim-cmp')
require('colorschemes-config.tokyonight')


