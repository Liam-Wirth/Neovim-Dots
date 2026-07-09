-- Bootstrap: leader key must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Environment detection
--
-- vim.g.worklaptop: manually-set marker (`touch ~/.worklaptop`) for corp
-- laptops. Kept as-is for backwards compatibility with existing checks.
--
-- vim.g.is_cloud_desktop: auto-detected. Amazon Cloud Desktops have a
-- `dev-dsk-*.amazon.com` hostname and a `/apollo` directory; 
--
-- vim.g.is_amazon_machine: 
local f = io.open(os.getenv("HOME") .. "/.worklaptop", "rb")
if f then f:close() end
vim.g.worklaptop = (f ~= nil)

local hostname = vim.uv.os_gethostname()
vim.g.is_cloud_desktop = hostname:match("^dev%-dsk%-.*%.amazon%.com$") ~= nil
   or vim.uv.fs_stat("/apollo") ~= nil

vim.g.is_amazon_machine = vim.g.worklaptop or vim.g.is_cloud_desktop

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
