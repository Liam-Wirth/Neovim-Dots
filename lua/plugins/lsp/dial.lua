return {
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
}
