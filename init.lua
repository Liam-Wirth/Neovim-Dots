vim.g.mapleader = " "
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828", fg = "#ebdbb2" })       -- Gruvbox colors
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#282828", fg = "#a89984" })

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
