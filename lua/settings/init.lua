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
set.expandtab = true 
set.smartindent = true
set.smarttab = true
set.shiftwidth = 3
set.showtabline = 2
vim.o.termguicolors = true
set.autochdir = true
set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

vim.opt.list = true
-------------------------------------------------------------------------------------------------------------
--                                                    ListChars                                            -- -------------------------------------------------------------------------------------------------------------
local tab = [[,tab:»■ ]]
local tab2 = [[,tab:→\ ]]
local tab3 = [[,tab:\ \ ]]
local extends = [[,extends:❯]]
local nbsp = [[,nbsp:␣]]
local precedes = [[,precedes:❮]]
vim.cmd("set listchars=eol:" .. "↩" .. tab3 .. extends .. precedes .. nbsp)



-------------------------------------------------------------------------------------------------------------
--                                                    ListChars                                            -- -------------------------------------------------------------------------------------------------------------
set.splitbelow = true
set.splitright = true
set.wrap = true
set.scrolloff = 5
set.fileencoding = "utf-8"

set.termguicolors = true
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
vim.o.undofile = true

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
