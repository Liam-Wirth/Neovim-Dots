local icons = require("util.glyphs")
if not vim.g.vscode then
   return {
      "j-hui/fidget.nvim",
      lazy = true,
      event = "LspAttach",
      opts = {
         progress = {
            suppress_on_insert = true,       -- Suppress new messages while in insert mode
            ignore_done_already = true,      -- Ignore new tasks that are already complete
            display = {
               render_limit = 5,              -- How many LSP messages to show at once
               done_ttl = 1,                  -- How long a message should persist after completion
               done_icon = icons.ui.Accepted, -- Icon shown when all LSP progress tasks are complete
            },
         },
         notification = {
            override_vim_notify = false, -- Automatically override vim.notify() with Fidget
            window = {
               winblend = 100,           -- Background color opacity in the notification window
               group_separator = "---",  -- Separator between notification groups
               zindex = 75,              -- Stacking priority of the notification window
            },
         },
      },
      keys = {
         { "<leader>ef", "<cmd>Fidget clear<cr>", desc = "Show/Hide Fidget" }
      }
   }
end
