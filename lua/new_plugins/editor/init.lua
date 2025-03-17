return {
   require("new_plugins.editor.neotree"),
   require("new_plugins.editor.mini"),
   require("new_plugins.editor.edgy"),
   require("new_plugins.editor.dial"),

   "mbbill/undotree",

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
      "lervag/vimtex",
      --NOTE: this plugin needs to be explicitly NOT Lazy loaded, as it lazy loads itself upon entering a latex buffer
      lazy = false,
   },
   { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
   {
      "windwp/nvim-ts-autotag",
      event = "BufEnter",
      opts = {},
   },
}
