-- Generic UI chrome: better vim.ui.select/input, keymap hints, notifications,
-- buffer tabs, and indent guides.
local ret = {
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
      opts = {
         select = {
            backend = { "telescope", "builtin" },
            telescope = require("telescope.themes").get_cursor(),
         },
      },
   },
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
         },
      },
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
