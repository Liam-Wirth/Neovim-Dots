local vim = vim

GruvColors = {
   bg = "#282c34",
   red = "#cc241d",
   green = "#98971a",
   yellow = "#d79921",
   blue = "#458588",
   purple = "#b16286",
   aqua = "#689d6a",
   gray = "#a89984",
   orange = "#d65d0e",
   bold_orange = "#af3a03",
   bold_gray = "#928374",
   bold_red = "#9d0006",
   bold_green = "#79740e",
   bold_yellow = "#b57614",
   bold_blue = "#076678",
   bold_purple = "#8f3f71",
   bold_aqua = "#427b58",
   bold_fg = "#3c3836",
   fg = "#282828"
}
local ret = {
   {
      "NTBBloodbath/doom-one.nvim",
      lazy = true,
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
            inverse = false,   -- invert background for search, diffs, statuslines and errors
            contrast = "hard", -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {
               Normal = {
                  fg = "#ebdbb2",
               }
            },
            dim_inactive = false,
            -- transparent_mode = vim.g.transparent_enabled,
            transparent_mode = true,
         })
      end,
   },
   {
      "https://github.com/sainnhe/everforest",
      lazy = false,
   },
   {
      "https://github.com/luisiacc/gruvbox-baby",
   }
}



-- gruvbox color fix for untyped buffers
local function apply_gruvbox_fixes()
   if vim.g.colors_name == "gruvbox" then
      -- Fix text visibility in untyped/no-filetype buffers while respecting transparent mode
      vim.api.nvim_set_hl(0, "Normal", { fg = "#ebdbb2" })  -- Don't force bg when transparent
      vim.api.nvim_set_hl(0, "NonText", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#928374" })
      vim.api.nvim_set_hl(0, "Conceal", { fg = "#ebdbb2" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#504945" })  -- More visible than #3c3836
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#7c6f64" })  -- Don't force bg when transparent
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })  -- Keep transparent
      -- Ensure text in untyped buffers is bright enough
      vim.api.nvim_set_hl(0, "Whitespace", { fg = "#504945" })
   end
end

vim.api.nvim_create_autocmd("ColorScheme", {
   pattern = "*",
   callback = apply_gruvbox_fixes
})

-- Apply fixes when vim starts
vim.api.nvim_create_autocmd("VimEnter", {
   callback = function()
      vim.schedule(apply_gruvbox_fixes)
   end
})

-- Apply fixes when entering any buffer (especially new ones)
vim.api.nvim_create_autocmd({"BufEnter", "BufNew", "BufWinEnter"}, {
   callback = function()
      vim.schedule(apply_gruvbox_fixes)
   end
})

-- Set gruvbox as the default colorscheme

return ret
