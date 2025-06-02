local kind = require("util.glyphs").kind
return {
   {
      "lervag/vimtex",
      --NOTE: this plugin needs to be explicitly NOT Lazy loaded, as it lazy loads itself upon entering a latex buffer
      lazy = false,
   },
   { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
   -- Handles size of buffer splits and stuff is nice
   {
      "folke/edgy.nvim",
      lazy = false,
      -- event = "BufreadPre",
      init = function()
         vim.opt.laststatus = 3
         vim.opt.splitkeep = "screen"
      end,
      opts = {
         animate = {
            -- I like my sidebars snappy, bruh
            enabled = false,
         },
         bottom = {
            -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
            {
               ft = "toggleterm",
               size = { height = 0.4 },
               filter = function(buf, win)
                  return vim.api.nvim_win_get_config(win).relative == ""
               end,
            },
            {
               ft = "lazyterm",
               title = "LazyTerm",
               size = { height = 0.4 },
               filter = function(buf)
                  return not vim.b[buf].lazyterm_cmd
               end,
            },
            "Trouble",
            { ft = "qf",            title = "QuickFix" },
            {
               ft = "help",
               size = { height = 20 },
               -- only show help buffers
               filter = function(buf)
                  return vim.bo[buf].buftype == "help"
               end,
            },
            { ft = "spectre_panel", size = { height = 0.4 } },
         },
         left = {
            {
               title = "Neo-Tree",
               ft = "neo-tree",
               filter = function(buf)
                  return vim.b[buf].neo_tree_source == "filesystem"
               end,
               size = { height = 0.5, width = 0.2 },
            },
            {
               title = "Neo-Tree Git",
               ft = "neo-tree",
               filter = function(buf)
                  return vim.b[buf].neo_tree_source == "git_status"
               end,
               pinned = false,
               open = "Neotree position=right git_status",
            },
            {
               title = "Neo-Tree Buffers",
               ft = "neo-tree",
               filter = function(buf)
                  return vim.b[buf].neo_tree_source == "buffers"
               end,
               pinned = false,
               open = "Neotree position=top buffers",
            },
            {
               ft = "Outline",
               pinned = false,
               open = "SymbolsOutlineOpen",
            },
            -- any other neo-tree windows
            "neo-tree",
         },
      },
   },
   {
      "folke/todo-comments.nvim",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
      },
      keys = {
         {
            "<leader>ext",
            "<cmd>Trouble todo",
            desc = "Open Project's TODO entries in Trouble"
         }
      }
   },
   {
      "folke/trouble.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      event = { "BufReadPost", "BufNewFile" },
      lazy = true,
      opts = {
      },
      keys = {
         {
            "<leader>exx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Trouble Diagnostics"
         },
         {
            "<leader>exc",
            "<cmd>Troubl symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)"
         }
      }
   },
   {
      "mbbill/undotree",
   },
   { "echasnovski/mini.comment",                    version = false, lazy = true, event = { "BufEnter" } },
   {
      "echasnovski/mini.surround",
      opts = {
         mappings = {
            add = "gza",            -- Add surrounding in Normal and Visual modes
            delete = "gzd",         -- Delete surrounding
            find = "gzf",           -- Find surrounding (to the right)
            find_left = "gzF",      -- Find surrounding (to the left)
            highlight = "gzh",      -- Highlight surrounding
            replace = "gzr",        -- Replace surrounding
            update_n_lines = "gzn", -- Update `n_lines`
         },
      },
   },
   { "echasnovski/mini.splitjoin", version = false, lazy = true, event = { "BufEnter" } },
   { "echasnovski/mini.bracketed", version = false, lazy = true, event = { "BufEnter" } },
   { "echasnovski/mini.pairs",     version = false, lazy = true, event = { "BufEnter" }, opts = {}, },
   { "echasnovski/mini.icons",     version = false, lazy = true },
   {
      "windwp/nvim-ts-autotag",
      event = "BufEnter",
      opts = {},
   },
   {
      "LunarVim/bigfile.nvim",
      lazy = false,
      opts = {
         filesize = 2,      -- size of the file in MiB, the plugin round file sizes to the closest MiB
         pattern = { "*" }, -- autocmd pattern or function see <### Overriding the detection of big files>
         features = {       -- features to disable
            "indent_blankline",
            "illuminate",
            "lsp",
            "treesitter",
            "syntax",
            "matchparen",
            "vimopts",
            "filetype",
         },
      }
   }
}
