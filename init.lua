local set = vim.opt
local vim = vim

vim.o.termguicolors = true -- Needs to be set before certain plugins load
vim.g.mapleader = " "
vim.opt.list = true
vim.o.encoding = "UTF-8"
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
set.splitbelow = true
set.splitright = true
set.wrap = true
set.scrolloff = 5
set.fileencoding = "utf-8"
set.relativenumber = true
set.number = true
set.cursorline = true
set.numberwidth = 4
set.ignorecase = true
set.hlsearch = true
set.colorcolumn = "99999"
set.signcolumn = "yes"
set.showtabline = 2
set.cmdheight = 1
set.pumheight = 10
set.splitbelow = true
set.splitright = true
set.expandtab = false
set.smartindent = true
set.smarttab = true
set.shiftwidth = 3
set.showtabline = 2
set.autochdir = true
set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

vim.opt.list = true
vim.g.t_Co = "256"
vim.o.cursorline = true
--no bell pls
set.belloff = all

--control options
set.mousefocus = true
set.sidescroll = 50

vim.notify = require("notify")
vim.o.syntax = on
vim.o.completeopt = "menuone,noselect"
vim.o.undofile = false

-- disable netrw at the very start of your init.lua (strongly advised)
-- (For Nvim Tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
require("plugins")
require("impatient")
require("plugins.lookandfeel.nvimtree")
require("plugins.discordrpc")
require("plugins.lookandfeel.indentblankline")

require("plugins.treesitter")
require("lsp-config.language-servers")
require("lsp-config.mason")
require("lsp-config.lsp-config")

require("keybinds")

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("ColoringFuckery", { clear = true }),
	pattern = "*",
	callback = function()
		for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})
vim.cmd([[colorscheme doom-one]])
--TODO: orgnize these options.
local font = "JetBrainsMonoExtraBold" .. [[\ ]] .. "Nerd" .. [[\ ]] .. "Font:h16"

--TODO: get indentblankline to not show the weird vertical lines on tabs
--",tab:" .. " ")
vim.cmd([[
    if exists("g:neovide")
      set guifont=]] .. font .. [[

]])

-------------------------------------------------------------------------------------------------------------
--                                                    ListChars                                            -- -------------------------------------------------------------------------------------------------------------
local tab = [[,tab:»■ ]]
local tab2 = [[,tab:→\ ]]
local tab3 = [[,tab:\ \ ]]
local extends = [[,extends:❯]]
local nbsp = [[,nbsp:␣]]
local precedes = [[,precedes:❮]]
vim.cmd("set listchars=eol:" .. "↩" .. tab2 .. extends .. precedes .. nbsp)

-------------------------------------------------------------------------------------------------------------
--                                                    ListChars                                            -- -------------------------------------------------------------------------------------------------------------

--!NOTE: [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
vim.g.doom_one_cursor_coloring = true
vim.g.doom_one_terminal_colors = true
vim.g.doom_one_italic_comments = true
vim.g.doom_one_enable_treesitter = true
vim.g.doom_one_diagnostics_text_color = false
vim.g.doom_one_transparent_background = false
vim.g.doom_one_pumblend_enable = false
vim.g.doom_one_pumblend_transparency = 20
vim.g.doom_one_plugin_neorg = true
vim.g.doom_one_plugin_barbar = false
vim.g.doom_one_plugin_telescope = false
vim.g.doom_one_plugin_neogit = true
vim.g.doom_one_plugin_nvim_tree = true
vim.g.doom_one_plugin_dashboard = true
vim.g.doom_one_plugin_startify = true
vim.g.doom_one_plugin_whichkey = true
vim.g.doom_one_plugin_indent_blankline = true
vim.g.doom_one_plugin_vim_illuminate = true
vim.g.doom_one_plugin_lspsaga = false
vim.cmd([[luafile ~/.config/nvim/lua/plugins/lookandfeel/indentblankline.lua]])

