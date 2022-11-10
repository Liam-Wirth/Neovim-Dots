require('settings')
require('settings.lookandfeel')

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

local vim = vim;

vim.cmd("colorscheme doom-one")
vim.cmd([[
    luafile ~/.config/nvim/lua/settings/lookandfeel.lua
    luafile ~/.config/nvim/lua/plugins/todo-comments.lua
    luafile ~/.config/nvim/lua/settings/init.lua
]])
--TODO
--HACKS
--
