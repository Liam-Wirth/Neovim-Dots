require("config.options")
require("config.autocmds")
require("config.listchars")
require("config.keymaps")
--NOTE: putting this here, probably a bad idea
vim.opt.termguicolors = true
vim.opt.background = "dark"
if vim.g.is_vscode
then
   vim.cmd [[colorscheme doom-one]]
else
   vim.cmd [[colorscheme gruvbox]]
end


-- WSL yank support

local clip = '/mnt/c/Windows/System32/clip.exe' -- change this path according to your mount point

-- Check if we are in WSL
local is_wsl = os.getenv("is_wsl")

if is_wsl and vim.fn.executable(clip) == 1 then
    -- Set up clipboard to use clip.exe
    vim.api.nvim_set_option('clipboard', 'unnamedplus')

    -- Create an autocommand group for yanking to the clipboard
    vim.api.nvim_exec([[
        augroup WSLYank
            autocmd!
            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(']] .. clip .. [[', getreg('"')) | endif
        augroup END
    ]], false)
end

