-- Diagnostics/TODO list UI (Trouble) and TODO-comment highlighting.
return {
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
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)"
         }
      }
   },
}
