local kind_icons = require("util.glyphs").kind_icons
local glyphs = require('util.glyphs')
local ret = {
   {
      'utilyre/barbecue.nvim',
      lazy = true,
      event = "BufReadPost",
      name = 'barbecue',
      version = '*',
      dependencies = {
         'SmiteshP/nvim-navic',
         'nvim-tree/nvim-web-devicons',
      },
      opts = {
         show_basename = false,
         symbols = {
            ---Modification indicator.
            ---
            ---@type string
            modified = "●",

            ---Truncation indicator.
            ---
            ---@type string
            ellipsis = "…",

            ---Entry separator.
            ---
            ---@type string
            separator = "",
         },
         context_follow_icon_color = true,
      },
   },
   { "hrsh7th/cmp-nvim-lsp" },
   {
      "folke/neodev.nvim",
      lazy = true,
      event = "BufReadPost",
      opts = {
         debug = true,
         experimental = {
            pathStrict = true,
         },
      },
   },
   {
      "hiphish/rainbow-delimiters.nvim",
      lazy = false,
      event = "BufReadPost",
      config = function()
         -- This module contains a number of default definitions
         local rainbow_delimiters = require 'rainbow-delimiters'

         vim.g.rainbow_delimiters = {
            strategy = {
               [''] = rainbow_delimiters.strategy['global'],
               commonlisp = rainbow_delimiters.strategy['local'],
            },
            query = {
               [''] = 'rainbow-delimiters',
               lua = 'rainbow-blocks',
               latex = 'rainbow-blocks',
            },
            highlight = {
               'RainbowDelimiterRed',
               'RainbowDelimiterYellow',
               'RainbowDelimiterBlue',
               'RainbowDelimiterOrange',
               'RainbowDelimiterGreen',
               'RainbowDelimiterViolet',
               'RainbowDelimiterCyan',
            },
            blacklist = { 'c' },
         }
      end
   },
   {
      'p00f/clangd_extensions.nvim',
      lazy = false,
      config = function()
         require("clangd_extensions").setup({
            inlay_hints = {
               inline = vim.fn.has("nvim-0.10") == 1,
               -- Options other than `highlight' and `priority' only work
               -- if `inline' is disabled
               -- Only show inlay hints for the current line
               only_current_line = false,
               -- Event which triggers a refresh of the inlay hints.
               -- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
               -- not that this may cause  higher CPU usage.
               -- This option is only respected when only_current_line and
               -- autoSetHints both are true.
               only_current_line_autocmd = { "CursorHold" },
               -- whether to show parameter hints with the inlay hints or not
               show_parameter_hints = true,
               -- prefix for parameter hints
               parameter_hints_prefix = "<- ",
               -- prefix for all the other hints (type, chaining)
               other_hints_prefix = "=> ",
               -- whether to align to the length of the longest line in the file
               max_len_align = false,
               -- padding from the left if max_len_align is true
               max_len_align_padding = 1,
               -- whether to align to the extreme right or not
               right_align = false,
               -- padding from the right if right_align is true
               right_align_padding = 7,
               -- The color of the hints
               highlight = "Comment",
               -- The highlight group priority for extmark
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
               }
            },
            vim.keymap.set('n', '<leader>bi', '<cmd>ClangdSymbolInfo<CR>')
         })
      end
   },
   -- 'jose-elias-alvarez/null-ls.nvim',
   {
      'stevearc/aerial.nvim',
      lazy = true,
      opts = {
         backends = { 'lsp', 'treesitter', 'markdown', 'man' },
         on_attach = function(bufnr)
            vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
            vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
         end,
         default_direction = "prefer_left",
      },
      cmd = { 'AerialOpen', 'AerialToggle' },
   },
   {
      'simrat39/rust-tools.nvim',
      lazy = true,
      event = "BufReadPost",
      config = function()
      end,
   },
   {
      -- lsp_signature | shows the signature of a function when typing parameters
      'ray-x/lsp_signature.nvim',
      lazy = true,
      event = "BufReadPost",
      config = function()
         require('lsp_signature').setup({
            floating_window = false
         })
      end
   },
   {
      "monaqa/dial.nvim",
      lazy = true,
      event = { "BufreadPost", "BufreadPre" },
      config = function()
         local augend = require("dial.augend")
         require("dial.config").augends:register_group {
            default = {
               augend.constant.new {
                  elements = { "and", "or" },
                  word = true,   -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
                  cyclic = true, -- "or" is incremented into "and".
               },
               augend.constant.new {
                  elements = { "&&", "||" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "++", "--" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "+=", "-=" },
                  word = false,
                  cyclic = true,
               },
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.date.alias["%Y/%m/%d"],
               augend.constant.alias.bool,
            },
            typescript = {
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.constant.new { elements = { "let", "const" } },
            },
            visual = {
               augend.integer.alias.decimal,
               augend.integer.alias.hex,
               augend.date.alias["%Y/%m/%d"],
               augend.constant.alias.alpha,
               augend.constant.alias.Alpha,
            },
         }
      end
   },
   {
      'nvim-orgmode/orgmode',
      dependencies = {
         { 'nvim-treesitter/nvim-treesitter', lazy = true },
         { 'akinsho/org-bullets.nvim',        lazy = true },
      },
      event = 'VeryLazy',
      config = function()
         -- Load treesitter grammar for org

         -- Setup treesitter
         require('nvim-treesitter.configs').setup({
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = { 'org' },
            },
            ensure_installed = { 'org' },
         })

         -- Setup orgmode
         require('orgmode').setup({
            org_agenda_files = '~/orgfiles/**/*',
            org_default_notes_file = '~/orgfiles/refile.org',
         })
      end,
   },
   {
      'lukas-reineke/headlines.nvim',
      dependencies = "nvim-treesitter/nvim-treesitter",
      config = true, -- or `opts = {}`
   },
   {
      'bfrg/vim-cpp-modern',
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
      end
   },
}

return ret
