require('settings')
require('settings.lookandfeel')

require('plugins')
    require('plugins.nvim-tree-config')
    require('plugins.bufferline')
    require('plugins.lualine')
    require('plugins.discordrpc')




require('plugins.treesitter')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.lsp-config')
        require('lsp-config.null-ls')
        require('lsp-config.nvim-cmp')
        require('lsp-config.luasnip')

local vim = vim;

vim.cmd("colorscheme doom-one")
--HACK way of fucking loading configuration files. Need to fix
vim.cmd([[
    luafile ~/.config/nvim/lua/settings/lookandfeel.lua
    luafile ~/.config/nvim/lua/settings/init.lua
]])
--TODO
--HACKS
--
