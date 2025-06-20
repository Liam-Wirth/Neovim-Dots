local vim = vim
vim.g.mapleader = " "
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828", fg = "#ebdbb2" }) -- Gruvbox colors
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#282828", fg = "#a89984" })

require("util")

-- setup specific for the work laptop :)
local f = io.open(os.getenv("HOME") .. "/.worklaptop", "rb")
if f then f:close() end
vim.g.worklaptop = (f ~= nil)



local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system {
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
   }
end
vim.loader.enable()
vim.opt.runtimepath:prepend(lazypath)

-- to anyone perusing my dots, all this is is a simple directory with like two lua files
-- in those files is just some extra config I did that is just for work, and doesn't need to be shared
-- Check if the private config exists

local lazyspec = {
   { import = "plugins" },
   { import = "plugins.lsp" },
   { import = "plugins.work" },
   { import = "plugins.editing" }
}
if vim.g.worklaptop then
   -- Add the private config to the Lua path
   local private_path = "~/.config/nvim-private/"
   
   -- Only add private config to lazyspec if the directory exists
   local private_dir = vim.fn.expand(private_path)
   if vim.fn.isdirectory(private_dir) == 1 then
      table.insert(lazyspec, { import = "nvim-private" })
   else
      vim.notify("nvim-private directory not found at " .. private_dir .. ". Skipping import.", vim.log.levels.WARN)
   end
end
require("lazy").setup({
   spec = lazyspec,
   performance = {},
})
require("plugins.colorscheme")

require("plugins.lsp.lspconfig")
require("config")
