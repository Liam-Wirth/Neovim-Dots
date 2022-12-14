--TODO get all of these dumbass require statements OUTTA HERE!!!
vim.g.mapleader=" "
require('plugins')
    require('plugins.lookandfeel.nvimtree')
    require('plugins.discordrpc')
    require('plugins.lookandfeel.indentblankline')

require('settings.init')
--HACK: why
vim.cmd[[luafile ~/.config/nvim/lua/plugins/lookandfeel/indentblankline.lua]]


require('plugins.treesitter')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.lsp-config')
        require('lsp-config.null-ls')
local vim = vim;

vim.cmd("colorscheme doom-one")
vim.g.mapleader = " "


require('keybinds')

--HACK way of fucking loading configuration files. Need to fix
vim.cmd[[luafile ~/.config/nvim/lua/plugins/lookandfeel/indentblankline.lua]]
