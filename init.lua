vim.o.termguicolors = true -- Needs to be set before certain plugins load
vim.g.mapleader = " "
vim.opt.list = true
vim.o.encoding = "UTF-8"
--NOTE: I moved alot of my settings to another file, just to keep this init smaller, probably stupid and pointless, whatever.
require('settings.init')

vim.o.inccommand = "split"
vim.o.background = "dark"
vim.o.expandtab = true


-- Case insensitive searching
vim.o.ignorecase = true

-- Override ignorecase if search contains caps
vim.o.smartcase = true

-- Highlights matching parens, braces, etc. Press % to jump to it.
vim.o.showmatch = true

-- Keep buffers open in background when the window is closed
vim.o.hidden = true

require('plugins')
require('impatient')
require('plugins.lookandfeel.nvimtree')
require('plugins.discordrpc')
require('plugins.lookandfeel.indentblankline')
--HACK: why
vim.cmd[[let g:doom_one_terminal_colors = v:true]]
vim.cmd [[luafile ~/.config/nvim/lua/plugins/lookandfeel/indentblankline.lua]]


require('plugins.treesitter')
require('lsp-config.language-servers')
require('lsp-config.mason')
require('lsp-config.lsp-config')



require('keybinds')

--HACK way of fucking loading configuration files. Need to fix
vim.cmd [[luafile ~/.config/nvim/lua/plugins/lookandfeel/indentblankline.lua]]
vim.cmd[[colorscheme doom-one]]
