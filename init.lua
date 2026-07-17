-- Bootstrap: leader key must be set before lazy.nvim loads plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "


---------------------------------------------------------------------------------------------------
---                                    ENVIRONMENT DETECTION
---------------------------------------------------------------------------------------------------
-- I try to use neovim for everything, and not everything needs the same configuration
-- thus, at startup my neovim config does a few things to try and figure out what OS we are running on,
-- and also for other indicators that might classify it as a work machine vs a personal machine,
-- throught the config you'll see conditional checks that enable/disable things based on these env-vars
local f = io.open(os.getenv("HOME") .. "/.worklaptop", "rb")
if f then f:close() end
vim.g.worklaptop = (f ~= nil)

local hostname = vim.uv.os_gethostname()
vim.g.is_cloud_desktop = hostname:match("^dev%-dsk%-.*%.amazon%.com$") ~= nil
   or vim.uv.fs_stat("/apollo") ~= nil

vim.g.is_amazon_machine = vim.g.worklaptop or vim.g.is_cloud_desktop

vim.g.vscode = vim.g.vscode or false


---------------------------------------------------------------------------------------------------
---                                    LazyVim Bootstrapping
---------------------------------------------------------------------------------------------------
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

-- Options must load before plugins (specs read vim.opt/vim.g at load time)
require("config.options")

-- Plugin setup
require("lazy").setup({
   spec = {
      { import = "plugins" },
      { import = "plugins.lsp" },
   },
   performance = {},
})

-- Keymaps and autocmds after plugins (some reference plugin modules)
require("config.autocmds")
require("config.keymaps")
