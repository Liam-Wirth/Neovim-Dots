--vim.g.maplocalleader = "\\"
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
vim.o.hidden = false
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
set.expandtab = true
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
vim.o.undofile = true;
vim.cmd([[
" vimscript config found here:
" https://vi.stackexchange.com/questions/6/how-can-i-use-the-undofile
" credit to user: D Ben Knoble
" Let's save undo info!
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile
]])
-- disable netrw at the very start of your init.lua (strongly advised)
-- (For Nvim Tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

set.splitkeep = "screen"
set.laststatus = 3

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
--[[
--
'comments'	  'com'     patterns that can start a comment line
'commentstring'   'cms'     template for comments; used for fold marker
'cursorline'	  'cul'	    highlight the screen line of the cursor
'cursorlineopt'	  'culopt'  settings for 'cursorline'
'expandtab'	  'et'	    use spaces when <Tab> is inserted
'lines'			    number of lines in the display
'linespace'	  'lsp'     number of pixel lines to use between characters
'list'			    show <Tab> and <EOL>
'listchars'	  'lcs'     characters for displaying in list mode
'mouse'			    enable the use of mouse clicks
'mousefocus'	  'mousef'  keyboard focus follows the mouse
'mousehide'	  'mh'	    hide mouse pointer while typing
'mousemodel'	  'mousem'  changes meaning of mouse buttons
'mousemoveevent'  'mousemev'  report mouse moves with <MouseMove>
'mousescroll'		    amount to scroll by when scrolling with a mouse
'mouseshape'	  'mouses'  shape of the mouse pointer in different modes
'mousetime'
'smarttab'	  'sta'     use 'shiftwidth' when inserting <Tab>
'smartindent'	  'si'	    smart autoindenting for C programs
'varsofttabstop'  'vsts'    a list of number of spaces when typing <Tab>
'vartabstop'	  'vts'	    a list of number of spaces for <Tab>s
'virtualedit'	  've'	    when to use virtual editing
--]]
