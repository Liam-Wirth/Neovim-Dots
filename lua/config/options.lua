-- Setup variables and settings
local set = vim.opt

vim.o.encoding = "UTF-8"
vim.o.inccommand = "split"

set.expandtab = true
set.smartindent = true
set.smarttab = true
set.shiftwidth = 3

set.ignorecase = true
set.smartcase = true
set.hlsearch = true
set.incsearch = true

-- Split settings
set.splitbelow = true
set.splitright = true

-- Interface settings
set.wrap = false
set.scrolloff = 5
set.relativenumber = true
set.number = true
set.cursorline = true
set.numberwidth = 2
set.colorcolumn = "100"
set.signcolumn = "yes"
set.showtabline = 2
set.cmdheight = 1
set.pumheight = 10
set.laststatus = 3
set.splitkeep = "screen"

set.hidden = true
set.belloff = "all"
set.mousefocus = true
set.sidescroll = 50

vim.diagnostic.config({
   virtual_text = true,
   signs = true,
   update_in_insert = false, -- Don't update diagnostics while typing
   underline = true,
   severity_sort = true,
   float = {
      border = "rounded",
      header = "",
      prefix = "",
   },
})

-- Undo file settings - Modern Lua approach
local undo_dir = vim.fn.expand("~/.vim/undo-dir")
if vim.fn.isdirectory(undo_dir) == 0 then
   vim.fn.mkdir(undo_dir, "p", 0700)
end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

-- Disable netrw for Nvim Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Highlight matching parens, braces, etc.
vim.o.showmatch = true

-- Completeopt and syntax
vim.o.completeopt = "menuone,noselect"
vim.o.syntax = "on"

-- Sign column and floating diagnostics

vim.opt.termguicolors = true
vim.opt.background = "dark"

-- vim.g settings and stuff
--

vim.g.loaded_python3_provider = 0

-- TODO: Remove if not needed - File type associations
vim.filetype.add({
   extension = {
      inc = "nasm",
      asm = "nasm",
      zsh = "zsh", -- Keep as zsh, not bash
      v = "verilog",
      tcl = "tcl",
   },
})
