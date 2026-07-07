-- Extra buffer highlighting: matching-reference highlight, color-code
-- previews, and rainbow bracket/delimiter pairs.
return {
   {
      "RRethy/vim-illuminate",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         delay = 200,
         large_file_cutoff = 2000,
         large_file_overrides = {
            providers = { "lsp" },
         },
      },
      config = function(_, opts)
         require("illuminate").configure(opts)

         local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
               require("illuminate")["goto_" .. dir .. "_reference"](false)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
         end

         map("]]", "next")
         map("[[", "prev")

         -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
         vim.api.nvim_create_autocmd("FileType", {
            callback = function()
               local buffer = vim.api.nvim_get_current_buf()
               map("]]", "next", buffer)
               map("[[", "prev", buffer)
            end,
         })
      end,
      keys = {
         { "]]", desc = "Next Reference" },
         { "[[", desc = "Prev Reference" },
      },
   },
   {
      "norcalli/nvim-colorizer.lua",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      config = function()
         require "colorizer".setup({
            "css",
            "javascript",
            html = { mode = "background" },
         }, { mode = "background" })
      end,
      keys = {
         "<leader>p", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" }
   },
   {
      "hiphish/rainbow-delimiters.nvim",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
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
}
