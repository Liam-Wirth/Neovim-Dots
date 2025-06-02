-- TODO: possibly move this to util
local glyphs = require("util.glyphs")
local colors_light = {
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
      opts = {},
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
         border = "1",
      },
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
   -- Context
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
   -- Helps with splits
   {
      "nvim-focus/focus.nvim",
      version = "*",
      config = function()
         require("focus").setup({
            autoresize = {
               enable = true,
            },
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
            },
         })
      end,
   },
   -- Pretty Buffer line
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
               reveal = { "close" },
            },
            config = function()
               require("transparent").clear_prefix("BufferLine")
               vim.g.transparent_groups = vim.list_extend(
                  vim.g.transparent_groups or {},
                  vim.tbl_map(function(v)
                     return v.hl_group
                  end, vim.tbl_values(require("bufferline.config").highlights))
               )
            end,
         },
      },
   },
   {
      "s1n7ax/nvim-window-picker",
      name = "window-picker",
      event = "VeryLazy",
      version = "2.*",
      config = function()
         local window_picker = require("window-picker")
         window_picker.setup({
            autoselect_one = false,
            include_current_win = false,
         })

         vim.api.nvim_create_autocmd("FileType", {
            pattern = "neo-tree",
            callback = function()
               vim.keymap.set("n", "<cr>", function()
                  local state = require("neo-tree.sources.manager").get_state("filesystem")
                  local node = state.tree:get_node()

                  if node.type == "file" then
                     -- Pick a window to open the file in
                     local picked_window_id = window_picker.pick_window()

                     if picked_window_id then
                        -- Switch to the picked window
                        vim.api.nvim_set_current_win(picked_window_id)

                        -- Open the file
                        require("neo-tree.sources.filesystem.commands").open()
                     end
                  else
                     -- Default neo-tree behavior for non-file nodes
                     require("neo-tree.sources.filesystem.commands").open()
                  end
               end, { buffer = true })
            end,
         })
      end,
   },
   {
      "hiphish/rainbow-delimiters.nvim",
      lazy = false,
      -- event = "BufReadPost",
      config = function()
         -- This module contains a number of default definitions
         local rainbow_delimiters = require("rainbow-delimiters")

         vim.g.rainbow_delimiters = {
            strategy = {
               [""] = rainbow_delimiters.strategy["global"],
               commonlisp = rainbow_delimiters.strategy["local"],
            },
            query = {
               [""] = "rainbow-delimiters",
               lua = "rainbow-blocks",
               latex = "rainbow-blocks",
            },
            highlight = {
               "RainbowDelimiterRed",
               "RainbowDelimiterYellow",
               "RainbowDelimiterBlue",
               "RainbowDelimiterOrange",
               "RainbowDelimiterGreen",
               "RainbowDelimiterViolet",
               "RainbowDelimiterCyan",
            },
            blacklist = { "c" },
         }
      end,
   },
   {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
         require("plugins.configs.indent-blankline")
      end,
      before = "gruvbox.nvim",
      after = "rainow-delimiters.nvim",
   },
}
