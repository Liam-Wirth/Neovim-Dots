require('settings')




require('plugins')
    require('plugins.nvim-tree-config')
    require('plugins.bufferline')
    require('plugins.lualine')
--require('colorschemes-config.tokyonight')
    require('plugins.discordrpc')

require('plugins.misc')



require('plugins.treesitter')
    require('lsp-config.language-servers')
        require('lsp-config.mason')
        require('lsp-config.lsp-config')
        require('lsp-config.null-ls')
        require('lsp-config.nvim-cmp')
        require('lsp-config.luasnip')

local vim = vim;

vim.cmd("colorscheme doom-one")
if vim.g.neovide == 1
then
    vim.cmd("g:neovide_cursor_animation_length=0.05")
    vim.cmd("g:neovide_cursor_trail_size = 0.5")
    vim.cmd("balls'")
    local font = "JetBrainsMonoExtraBold\b Nerd\b Font:h16"
    vim.cmd("set guifont="+ font )
end
