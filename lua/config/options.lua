vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
local set = vim.opt
local vim = vim
vim.opt.list = true
vim.o.encoding = "UTF-8"
vim.o.inccommand = "split"
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
set.wrap = false
set.scrolloff = 5
set.fileencoding = "utf-8"
set.relativenumber = true
set.number = true
set.cursorline = true
set.numberwidth = 2
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
set.hidden = true

vim.opt.list = true
vim.g.t_Co = "256"
vim.o.cursorline = true
--no bell pls
set.belloff = all

--control options
set.mousefocus = true
set.sidescroll = 50
vim.o.syntax = on
vim.o.completeopt = "menuone,noselect"
vim.o.undofile = false

-- disable netrw at the very start of your init.lua (strongly advised)
-- (For Nvim Tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
