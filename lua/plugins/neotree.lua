return {
   {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      lazy = false,
      dependencies = {
         "nvim-lua/plenary.nvim",
         "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
         "MunifTanjim/nui.nvim",
      },
      keys = {
         {
            "<leader>et",
            function()
               require("neo-tree.command").execute({
                  toggle = "true",
                  source = "filesystem",
                  position = "left",
               })
            end,
            desc = "Explorer NeoTree (cwd)",
         },
      },
      opts = {
         -- Neo-tree window options, including width
         window = {
            position = "left",
            width = 20, -- Set the window width here
            mapping_options = {
               noremap = true,
               nowait = true,
            },
         },
         event_handlers = {
            {
               event = "after_render",
               handler = function(state)
                  if state.current_position == "left" or state.current_position == "right" then
                     vim.api.nvim_win_call(state.winid, function()
                        local str = require("neo-tree.ui.selector").get()
                        if str then
                           _G.__cached_neo_tree_selector = str
                        end
                     end)
                  end
               end,
            },
         }
      }
   }
}

