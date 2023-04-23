--TODO: orgnize these options.
local font = "JetBrainsMonoExtraBold" .. [[\ ]] .. "Nerd" .. [[\ ]] .. "Font:h16"

--TODO: get indentblankline to not show the weird vertical lines on tabs
--",tab:" .. " ")
vim.cmd([[
    if exists("g:neovide")
      set guifont=]] .. font .. [[

]])

local set = vim.opt
local vim = vim
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
vim.g.t_Co = '256'
vim.o.cursorline = true
vim.o.syntax = on
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

--no bell pls
set.belloff = all

--control options
set.mousefocus = true
set.sidescroll = 50

vim.notify = require("notify")

vim.o.completeopt = "menuone,noselect"
vim.o.undofile = false

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
-------------------------------------------------------------------------------------------------------------
--                                                    doom-one                                              -- --------------------------------------------------------------------------------------------------------------
--
vim.g.doom_one_cursor_coloring = false
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

