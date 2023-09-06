require("config.options")
require("config.autocmds")
require("config.listchars")
require("config.keymaps")
--NOTE: putting this here, probably a bad idea
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd[[colorscheme doom-one]]

