-- Extra LSP-adjacent tooling that doesn't belong in lspconfig.lua's server
-- table: clangd's custom UI extensions, function-signature popups,
-- markdown headline styling, and legacy vim-regex C/C++ highlighting.
local ret = {
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
                  Compound = "",
                  Recovery = "",
                  TranslationUnit = "",
                  PackExpansion = "",
                  TemplateTypeParm = "",
                  TemplateTemplateParm = "",
                  TemplateParamObject = "",
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
      "lukas-reineke/headlines.nvim",
      dependencies = "nvim-treesitter/nvim-treesitter",
      ft = { "org", "markdown" }, -- was eager; only useful in these filetypes
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
}

if not vim.g.vscode then
   return ret
end
