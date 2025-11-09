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

local ret = {
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
     event = "VeryLazy",
     keys = {
       {
         "<leader>un",
         function() require("notify").dismiss({ silent = true, pending = true }) end,
         desc = "Dismiss all Notifications",
       },
     },
     opts = {
       timeout = 2000,
       render = "compact",
       background_colour = "#000000",
       max_height = function() return math.floor(vim.o.lines * 0.75) end,
       max_width  = function() return math.floor(vim.o.columns * 0.75) end,
     },
     init = function()
       vim.notify = require("notify")
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
   {
      "nvim-focus/focus.nvim",
      version = "*",
      config = function()
         require("focus").setup({
            autoresize = {
               enable = true,
            },
            ui = {
               number = true,
               relativenumber = false,
               hybridnumber = false,
               absolutenumber_unfocussed = false,

               cursorline = true,
               cursorcolumn = false,
               colorcolumn = {
                  enable = false,
                  list = "+1",
               },
               signcolumn = true,
               winhighlight = false,
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
            close_command = "bdelete! %d",
            right_mouse_command = "bdelete! %d",
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            diagnostics = "nvim_lsp",
            always_show_bufferline = true,
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
      "hiphish/rainbow-delimiters.nvim",
      lazy = false,
      config = function()
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
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         indent = {
            char = "│",
            tab_char = "│",
         },
         scope = { enabled = true },
         exclude = {
            filetypes = {
               "help",
               "alpha",
               "dashboard",
               "neo-tree",
               "Trouble",
               "trouble",
               "lazy",
               "mason",
               "notify",
               "toggleterm",
               "lazyterm",
            },
         },
      },
   },
}

if not vim.g.vscode then
   return ret
end
