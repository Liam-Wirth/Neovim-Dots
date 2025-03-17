return {
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
         -- Neo-tree filesystem always takes half the screen height
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
}
