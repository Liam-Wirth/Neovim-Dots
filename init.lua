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
   performance = {},
   spec = {
      { import = "plugins" },
      { import = "plugins.lsp" },
      { import = "plugins.editing" }
   }
})
require("plugins.colorscheme")

require("plugins.lsp.lspconfig")
require("config")
