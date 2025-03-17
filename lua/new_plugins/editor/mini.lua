return {
   -- Mini.comment: Better comment handling
   {
      "echasnovski/mini.comment",
      version = false,
      lazy = true,
      event = { "BufEnter" },
      opts = {}
   },

   -- Mini.surround: Better surrounding handling (brackets, quotes, etc.)
   {
      "echasnovski/mini.surround",
      version = false,
      lazy = true,
      event = { "BufEnter" },
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

   -- Mini.splitjoin: Switch between single-line and multi-line constructs
   {
      "echasnovski/mini.splitjoin",
      version = false,
      lazy = true,
      event = { "BufEnter" },
      opts = {}
   },

   -- Mini.bracketed: Improved bracket navigation
   {
      "echasnovski/mini.bracketed",
      version = false,
      lazy = true,
      event = { "BufEnter" },
      opts = {}
   },

   -- Mini.pairs: Auto-pair brackets and quotes
   {
      "echasnovski/mini.pairs",
      version = false,
      lazy = true,
      event = { "BufEnter" },
      opts = {}
   },

   -- Mini.icons: Icons for filetypes and more
   {
      "echasnovski/mini.icons",
      version = false,
      lazy = true
   },
}
