-- ──────────────────────────────────────────────────────────────────────────────
-- Options: all vim.opt / vim.o / vim.g settings in one place
-- ──────────────────────────────────────────────────────────────────────────────

local opt = vim.opt

-- Encoding & preview
vim.o.encoding = "UTF-8"
vim.o.inccommand = "split"

-- Indentation
opt.expandtab = true
opt.smartindent = true
opt.smarttab = true
opt.shiftwidth = 3

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Interface
opt.wrap = false
opt.scrolloff = 5
opt.relativenumber = true
opt.number = true
opt.cursorline = true
opt.numberwidth = 2
opt.colorcolumn = "100"
opt.signcolumn = "yes"
opt.showtabline = 2
opt.cmdheight = 1
opt.pumheight = 10
opt.laststatus = 3
opt.showmatch = true

-- Misc
opt.hidden = true
opt.belloff = "all"
opt.mousefocus = true
opt.sidescroll = 50
opt.completeopt = "menuone,noselect"
vim.o.syntax = "on"

-- Appearance
opt.termguicolors = true
opt.background = "dark"

-- Float window highlight defaults (gruvbox-friendly)
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#282828", fg = "#a89984" })

-- List characters (visible whitespace when :set list)
opt.listchars = {
   eol = "↩",
   tab = "→ ",
   extends = "❯",
   precedes = "❮",
   nbsp = "␣",
}

-- Fold and diff fill characters
opt.fillchars = {
   foldopen = "▾",
   foldclose = "▸",
   fold = " ",
   foldsep = " ",
   diff = "╱",
   eob = " ",
}

-- ──────────────────────────────────────────────────────────────────────────────
-- Diagnostics
-- ──────────────────────────────────────────────────────────────────────────────

vim.diagnostic.config({
   virtual_text = true,
   signs = true,
   update_in_insert = false,
   underline = true,
   severity_sort = true,
   float = {
      border = "rounded",
      header = "",
      prefix = "",
   },
})

-- ──────────────────────────────────────────────────────────────────────────────
-- Persistent undo
-- ──────────────────────────────────────────────────────────────────────────────

local undo_dir = vim.fn.stdpath("data") .. "/undo"
if vim.fn.isdirectory(undo_dir) == 0 then
   vim.fn.mkdir(undo_dir, "p", 0700)
end
opt.undodir = undo_dir
opt.undofile = true

-- ──────────────────────────────────────────────────────────────────────────────
-- Disabled built-in plugins
-- ──────────────────────────────────────────────────────────────────────────────

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_python3_provider = 0

-- ──────────────────────────────────────────────────────────────────────────────
-- WSL clipboard support
-- ──────────────────────────────────────────────────────────────────────────────

vim.g.IS_WSL = os.getenv("is_wsl")

if vim.g.IS_WSL then
   local clip = "/mnt/c/Windows/System32/clip.exe"
   if vim.fn.executable(clip) == 1 then
      opt.clipboard = "unnamedplus"
      vim.api.nvim_create_augroup("WSLYank", { clear = true })
      vim.api.nvim_create_autocmd("TextYankPost", {
         group = "WSLYank",
         callback = function()
            if vim.v.event.operator == "y" then
               vim.fn.system(clip, vim.fn.getreg('"'))
            end
         end,
      })
   end
end

-- ──────────────────────────────────────────────────────────────────────────────
-- File type associations
-- ──────────────────────────────────────────────────────────────────────────────

vim.filetype.add({
   extension = {
      inc = "nasm",
      asm = "nasm",
      zsh = "zsh",
      v = "verilog",
      tcl = "tcl",
   },
})
