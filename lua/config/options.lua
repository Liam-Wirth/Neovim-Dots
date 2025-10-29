-- Setup variables and settings
local set = vim.opt

vim.o.encoding = "UTF-8"
vim.o.inccommand = "split"

-- Tab settings
set.expandtab = true
set.smartindent = true
set.smarttab = true
set.shiftwidth = 3

-- Searching settings
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
set.autochdir = true
set.laststatus = 3
set.splitkeep = "screen"

-- Misc settings
set.hidden = true
set.belloff = "all"
set.mousefocus = true
set.sidescroll = 50

-- Diagnostic settings
vim.diagnostic.config({
   virtual_text = true,
   signs = true,
   update_in_insert = true,
   underline = true,
   severity_sort = false,
   float = {
      border = 'rounded',
      header = '',
      prefix = '',
   },
})

-- Undo file settings
vim.cmd([[
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
]])

-- Disable netrw for Nvim Tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Highlight matching parens, braces, etc.
vim.o.showmatch = true

-- Completeopt and syntax
vim.o.completeopt = "menuone,noselect"
vim.o.syntax = "on"

-- Sign column and floating diagnostics
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])



-- vim.g settings and stuff
--

vim.g.loaded_python3_provider = 0

-- TODO: Fix
vim.filetype.add({
   extension = {
      inc = "nasm",
      asm = "nasm",
      zsh = "bash",
      v = "verilog",
      tcl = "tcl",
   },
})
