-- TODO: possibly move this to util
glyphs = require("util.glyphs")
colors_light = {
   red = "#cc241d",
   green = "#98971a",
   yellow = "#d79921",
   blue = "#458588",
   purple = "#b16286",
   aqua = "#689d6a",
   cyan = "#689d6a",
   gray = "#a89984",

}

return {
   {
      "folke/which-key.nvim",
      event = "VeryLazy",
      opts = {

      },
      keys = {
         {
            "<leader>?",
            function()
               require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
         },
      },
      win = {
         border = "1"
      }
   },
   {
      "rcarriga/nvim-notify",
      lazy = false,
      keys = {
         {
            "<leader>un",
            function()
               require("notify").dismiss({ silent = true, pending = true })
            end,
            desc = "Dismiss all Notifications",
         },
      },
      opts = {
         timeout = 3000,
         max_height = function()
            return math.floor(vim.o.lines * 0.75)
         end,
         max_width = function()
            return math.floor(vim.o.columns * 0.75)
         end,
      },
      init = function()
         -- when noice is not enabled, install notify on VeryLazy
         local Util = require("util.init")
         if not Util.has("noice.nvim") then
            Util.on_very_lazy(function()
               vim.notify = require("notify")
            end)
         end
      end,
   },
   {
      "stevearc/dressing.nvim",
      lazy = true,
      init = function()
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.select = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.select(...)
         end
         ---@diagnostic disable-next-line: duplicate-set-field
         vim.ui.input = function(...)
            require("lazy").load({ plugins = { "dressing.nvim" } })
            return vim.ui.input(...)
         end
      end,
   },
   {
      "SmiteshP/nvim-navic",
      lazy = true,
      init = function()
         vim.g.navic_silence = true
         require("util").on_attach(function(client, buffer)
            if client.server_capabilities.documentSymbolProvider then
               require("nvim-navic").attach(client, buffer)
            end
         end)
      end,
      opts = function()
         return {
            separator = " ",
            depth_limit = 5,
            icons = require("util.glyphs").kind,
            highlight = true,
            click = true,
         }
      end,
   },
   "nvim-tree/nvim-web-devicons",
   {
      "nvim-focus/focus.nvim",
      version = "*",
      config = function()
         require("focus").setup({
            ui = {
               number = true,                     -- Display line numbers in the focussed window only
               relativenumber = false,            -- Display relative line numbers in the focussed window only
               hybridnumber = false,              -- Display hybrid line numbers in the focussed window only
               absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

               cursorline = true,                 -- Display a cursorline in the focussed window only
               cursorcolumn = false,              -- Display cursorcolumn in the focussed window only
               colorcolumn = {
                  enable = false,                 -- Display colorcolumn in the foccused window only
                  list = "+1",                    -- Set the comma-saperated list for the colorcolumn
               },
               signcolumn = true,                 -- Display signcolumn in the focussed window only
               winhighlight = true,               -- Auto highlighting for focussed/unfocussed windows
            }
         })
      end,
   },
   {
      "akinsho/bufferline.nvim",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         options = {
            close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
            right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
            left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
            middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
            --separator_style = "slant",
            offsets = {
               {
                  filetype = "neo-tree",
                  raw = " %{%v:lua.__get_selector()%} ",
                  highlight = { sep = { link = "WinSeparator" } },
               },

            },
            hover = {
               enabled = true,
               delay = 2,
               reveal = { "close" }
            },
            config = function()
               require("transparent").clear_prefix("BufferLine")
               vim.g.transparent_groups = vim.list_extend(
                  vim.g.transparent_groups or {},
                  vim.tbl_map(function(v)
                     return v.hl_group
                  end, vim.tbl_values(require("bufferline.config").highlights))
               )
            end
         },
      },
   },
   {
      "s1n7ax/nvim-window-picker",
      name = "window-picker",
      event = "BufReadPost",
      version = "2.*",
      config = function()
         require "window-picker".setup()
      end,
   },
   {
      "xiyaowong/transparent.nvim",
      lazy = false,
      config = function()
         require("transparent").setup({ -- Optional, you don't have to run setup.
            groups = {                  -- table: default groups
               "Normal", "NormalNC", "Comment", "Constant", "Special", "Identifier",
               "Statement", "PreProc", "Type", "Underlined", "Todo", "String", "Function",
               "Conditional", "Repeat", "Operator", "Structure", "LineNr", "NonText",
               "SignColumn", "CursorLineNr", "EndOfBuffer",
            },
            {
               extra_groups = {
                  "NormalFloat",    -- plugins which have float panel such as Lazy, Mason, LspInfo
                  "NvimTreeNormal", -- NvimTree
                  "Neo-Tree",

               },
            },
            exclude_groups = {}, -- table: groups you don't want to clear
         })
      end
   },
   {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
   }
}
