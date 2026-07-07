-- Project-wide search and replace.
return {
   {
      "nvim-pack/nvim-spectre",
      lazy = true,
      cmd = "Spectre",
      opts = { open_cmd = "noswapfile vnew" },
      keys = {
         { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
      },
   },
}
