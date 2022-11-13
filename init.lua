--TODO get all of these dumbass require statements OUTTA HERE!!!
vim.cmd([[nnoremap <SPACE> <Nop>]])
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('plugins')
    require('plugins.lookandfeel.bufferline')
    require('plugins.lookandfeel.lualine')
    require('plugins.lookandfeel.notify')
    require('plugins.lookandfeel.nvimtree')
    require('plugins.lookandfeel.alpha')
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
