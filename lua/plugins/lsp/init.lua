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
   'p00f/clangd_extensions.nvim',
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
         require('orgmode').setup_ts_grammar()

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
      config = true,   -- or `opts = {}`
   },
}
return ret
