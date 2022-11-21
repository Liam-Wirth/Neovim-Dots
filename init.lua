--TODO get all of these dumbass require statements OUTTA HERE!!!
vim.cmd([[nnoremap <SPACE> <Nop>]])
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('plugins')
    require('plugins.lookandfeel.nvimtree')
    require('plugins.discordrpc')

require('settings.init')


require('plugins.treesitter')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.lsp-config')
        require('lsp-config.null-ls')
local vim = vim;

vim.cmd("colorscheme doom-one")
--HACK way of fucking loading configuration files. Need to fix
--
