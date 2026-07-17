-- Text-editing motions and operators: surround, split/join, bracket
-- navigation, autopairs, increment/decrement, HTML tag auto-rename, undo
-- history, and big-file safety (disables heavy features on huge buffers).
local ret = {
   {
      "mbbill/undotree",
   },
   {
      "echasnovski/mini.surround",
      opts = {
         mappings = {
            add = "gza",            -- Add surrounding in Normal and Visual modes
            delete = "gzd",         -- Delete surrounding
            find = "gzf",           -- Find surrounding (to the right)
            find_left = "gzF",      -- Find surrounding (to the left)
            highlight = "gzh",      -- Highlight surrounding
            replace = "gzr",        -- Replace surrounding
            update_n_lines = "gzn", -- Update `n_lines`
         },
      },
   },
   { "echasnovski/mini.splitjoin", version = false, lazy = true, event = { "BufEnter" } },
   { "echasnovski/mini.bracketed", version = false, lazy = true, event = { "BufEnter" } },
   { "echasnovski/mini.pairs",     version = false, lazy = true, event = { "BufEnter" }, opts = {}, },
   { "nvim-mini/mini.icons",       version = false, lazy = true, opts = {} },
   {
      "windwp/nvim-ts-autotag",
      event = "BufEnter",
      opts = {},
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
                  elements = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" },
                  word = true,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "++", "--" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "hidden", "shown" },
                  word = true,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "+=", "-=" },
                  word = false,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "<", ">"},
                  word = false,
                  cyclic = true,
               },
               augend.constant.new {
                  elements = { "<=", ">="},
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
}

if not vim.g.vscode then
   local norm = {
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
      }
   }
   vim.list_extend(ret, norm)
end

return ret
