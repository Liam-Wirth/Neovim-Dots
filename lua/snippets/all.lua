local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local f = ls.function_node


local sheb = "#!/usr/bin/env"
local shebmap = {
   python = sheb .. " python3",
   sh = sheb .. " bash",
   bash = sheb .. " bash",
   zsh = sheb .. " bash",
   node = sheb .. " node",
   javascript = sheb .. " node",
   ruby = sheb .. " node",
   perl = sheb .. " perl",
   lua = sheb .. " lua",
   php = sheb .. " php"
}
ls.add_snippets("all", {
   s("shebenv", {
      f(function ()
         local ft = vim.bo.filetype
         return shebmap[ft] or sheb
      end)
   })
})

