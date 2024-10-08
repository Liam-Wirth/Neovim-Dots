--All Mini cfgs
local wk = require("which-key")

return {
   { "echasnovski/mini.comment",   version = false, lazy = true, event = { "BufEnter" } },
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
   } }
