vim.g.mapleader = " "
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
vim.opt.runtimepath:prepend(lazypath)
require('lazy').setup({
   --defaults = { },
   performance = {},
   spec = {
      { import = "plugins" },
      --NOTE: Above could break things cause double import of a plugin, but maybe not
      --NOTE: Below is how I import from submodules beneath the plugins folder
      { import = "plugins.lsp" },
      { import = "plugins.editing" }
   }
})
--require("lua.plugins.colorscheme")
require("plugins.colorscheme")

require("config")
