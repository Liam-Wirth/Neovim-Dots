local vim = vim
ret = {
   {
      "NTBBloodbath/doom-one.nvim",
      lazy = false,
      init = function()
         vim.g.doom_one_cursor_coloring = true
         vim.g.doom_one_terminal_colors = true
         vim.g.doom_one_italic_comments = true
         vim.g.doom_one_enable_treesitter = true
         vim.g.doom_one_diagnostics_text_color = true
         vim.g.doom_one_transparent_background = false
         vim.g.doom_one_pumblend_enable = false
         --vim.g.doom_one_pumblend_transparency = 20
         vim.g.doom_one_plugin_neorg = true
         vim.g.doom_one_plugin_barbar = false
         vim.g.doom_one_plugin_telescope = true
         vim.g.doom_one_plugin_neogit = true
         vim.g.doom_one_plugin_nvim_tree = true
         --vim.g.doom_one_plugin_dashboard = true
         --vim.g.doom_one_plugin_startify = true
         vim.g.doom_one_plugin_whichkey = true
         vim.g.doom_one_plugin_indent_blankline = true
         vim.g.doom_one_plugin_vim_illuminate = true
         vim.g.doom_one_plugin_lspsaga = false
      end,
   },
   {
      "ellisonleao/gruvbox.nvim",
      lazy = false,
      init = function()
         require("gruvbox").setup({
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
               strings = false,
               comments = true,
               operators = false,
               folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = false,     -- invert background for search, diffs, statuslines and errors
            contrast = "hard",   -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {
            },
            dim_inactive = false,
            -- transparent_mode = vim.g.transparent_enabled,
            transparent_mode = true,
         })
      end,
   },
}

vim.cmd [[
"highlight! link Normal GruvboxBG0
"highlight! link NeotreeNormalNC GruvboxBG0
]]
return ret
