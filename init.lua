-- Bootstrap: leader key must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Environment detection
local f = io.open(os.getenv("HOME") .. "/.worklaptop", "rb")
if f then f:close() end
vim.g.worklaptop = (f ~= nil)
vim.g.vscode = vim.g.vscode or false

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--single-branch",
      "https://github.com/folke/lazy.nvim.git",
      lazypath,
   })
end
vim.opt.runtimepath:prepend(lazypath)
vim.loader.enable()

-- Plugin setup
require("lazy").setup({
   spec = {
      { import = "plugins" },
      { import = "plugins.lsp" },
   },
   performance = {},
})

-- Load user config (options, autocmds, keymaps)
require("config")
