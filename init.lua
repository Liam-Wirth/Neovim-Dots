local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  }
end
vim.loader.enable()
local plugins = require("plugins")
vim.opt.runtimepath:prepend(lazypath)
require('lazy').setup(plugins, {
  defaults = { lazy = true },
  performance = {},
})
require("config")
require("config.colorscheme")
