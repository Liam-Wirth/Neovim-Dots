-- local wk = require("which-key")
local ret = {
   {
      "utilyre/barbecue.nvim", -- TODO: Eventually phase out for lspsaga
      lazy = true,
      event = "BufReadPost",
      name = "barbecue",
      version = "*",
      dependencies = {
         "SmiteshP/nvim-navic",
         "nvim-tree/nvim-web-devicons",
      },
      opts = {
         show_basename = false,
         symbols = {
            ---Modification indicator.
            ---@type string
            modified = "●",

            ---Truncation indicator.
            ---@type string
            ellipsis = "…",

            ---Entry separator.
            ---@type string
            separator = "",
         },
         context_follow_icon_color = true,
      },
   },
   {
      "neovim/nvim-lspconfig",
      dependencies = {
         {
            "williamboman/mason-lspconfig.nvim", -- MUST be set up before `nvim-lspconfig`
            dependencies = {
               "williamboman/mason.nvim",
               cmd = "Mason",
               lazy = false,
               keys = { { "<leader>em", "<cmd>Mason<cr>", desc = "Mason" } },
            },
         },
         { "folke/neodev.nvim",  opts = {} },
      },
   },
   { "hrsh7th/cmp-nvim-lsp" },
   {
      "folke/neodev.nvim",
      lazy = true,
      event = "BufReadPost",
      opts = {
         library = {
            enabled = true,
            runtime = true,
            types = true,
            plugins = true,
         },
         setup_jsonls = true,
         lspconfig = true,
         pathStrict = true,
      },
   },
   {
      "p00f/clangd_extensions.nvim",
      lazy = false,
      config = function()
         require("clangd_extensions").setup({
            inlay_hints = {
               inline = vim.fn.has("nvim-0.10") == 1,
               only_current_line = false,
               only_current_line_autocmd = { "CursorHold" },
               show_parameter_hints = true,
               parameter_hints_prefix = "<- ",
               other_hints_prefix = "=> ",
               max_len_align = false,
               max_len_align_padding = 1,
               right_align = false,
               right_align_padding = 7,
               highlight = "Comment",
               priority = 100,
            },
            ast = {
               kind_icons = {
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
               },
            },
         })
      end,
      keys = {
         {
            "<leader>bi",
            desc = "Clangd Symbol Info",
         },
      },
   },
   {
      -- lsp_signature | shows the signature of a function when typing parameters
      "ray-x/lsp_signature.nvim",
      lazy = true,
      event = "BufReadPost",
      config = function()
         require("lsp_signature").setup({
            floating_window = false,
         })
      end,
   },
   {
      "lukas-reineke/headlines.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true, -- or `opts = {}`
   },
   {
      "bfrg/vim-cpp-modern",
      lazy = false,
      config = function()
         vim.cmd([[
            " Disable function highlighting (affects both C and C++ files)
            let g:cpp_function_highlight = 1

            " Enable highlighting of C++11 attributes
            let g:cpp_attributes_highlight = 1

            " Highlight struct/class member variables (affects both C and C++ files)
            let g:cpp_member_highlight = 1

            " Put all standard C and C++ keywords under Vim's highlight group 'Statement'
            " (affects both C and C++ files)
            let g:cpp_simple_highlight = 0
         ]])
      end,
   },
   {
      "L3MON4D3/LuaSnip",
      dependencies = {
         "rafamadriz/friendly-snippets",
         config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_lua").load({
               paths = {
                  vim.fn.stdpath("config") .. "/lua/snippets/all.lua",
                  "$HOME/.config/nvim/lua/snippets/all.lua",
                  "$HOME/.config/nvim/lua/snippets/",
               },
            })
            require("lua/snippets/")
         end,
      },
      opts = {
         history = true,
         delete_check_events = "TextChanged",
      },
      -- stylua: ignore
      keys = {
         {
            "S-<tab>",
            function()
               return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "S-<tab>"
            end,
            expr = true,
            silent = true,
            mode = "i",
         },
         { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
         { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
      },
   },
}

if not vim.g.vscode then
   return ret
end
