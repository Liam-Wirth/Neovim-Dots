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
               SignColumn = { bg = "#ff9900" }
            },
            dim_inactive = false,
            --transparent_mode = vim.g.transparent_enabled,
            transparent_mode = true,
         })
      end,
   },
   -- {
   --    "morhetz/gruvbox",
   --    lazy = false,
   --    init = function()
   --       vim.cmd [[
   --          set termguicolors
   --          let g:gruvbox_contrast_dark='hard'
   --          let g:gruvbox_contrast_light='hard'
   --          let g:gruvbox_transparent_bg=1
   --          let g:gruvbox_invert_signs=1
   --          let g:gruvbox_sign_column='bg'
   --          colorscheme gruvbox
   --          hi LspCxxHlGroupMemberVariable guifg=#83a598
   --       ]]
   --    end
   -- }
   {
      'zefei/vim-colortuner',
      lazy = true,
   },
}
--TODO: set these colors
---vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, colors.base2, fg = colors.green })
--im.api.nvim_set_hl(0, "NavicIconsModule", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsClass", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsField", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, colors.base2, fg = colors.green })
--im.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsString", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsArray", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsObject", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsKey", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsNull", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicText", { default = true, colors.base2, fg = "#ffffff" })
--im.api.nvim_set_hl(0, "NavicSeparator", { default = true, colors.base2, fg = "#ffffff" })
return ret
