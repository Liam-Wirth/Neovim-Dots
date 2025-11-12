require("config.options")
require("config.autocmds")
require("config.keymaps")


-- WSL yank support
local clip = '/mnt/c/Windows/System32/clip.exe'

-- Check if we are in WSL
vim.g.IS_WSL = os.getenv("is_wsl")

if vim.g.IS_WSL and vim.fn.executable(clip) == 1 then
    -- Set up clipboard to use clip.exe
    vim.opt.clipboard = 'unnamedplus'

    -- Create an autocommand group for yanking to the clipboard
    vim.api.nvim_create_augroup("WSLYank", { clear = true })
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = "WSLYank",
        callback = function()
            if vim.v.event.operator == 'y' then
                vim.fn.system(clip, vim.fn.getreg('"'))
            end
        end,
    })
end
-- NOTE: Might replace this with ascii type chars inthe future
vim.opt.listchars = {
    eol = "↩",
    tab = "→ ",
    extends = "❯",
    precedes = "❮",
    nbsp = "␣",
}


-- vim.opt.listchars= {
-- eol = "<-"
-- tab = "->"
-- extends = ">"
-- precedes = "<"
-- nbsp = "_"
-- }
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
