--NOTE: Just learned that function arguments are completely optional in lua.
local wk = require("which-key")
local pluginlist = require("util.plugins")
local nmap = function(keys, func, desc, plugin)
    if desc and plugin then
           desc = plugin..": "..desc 
          end

         ,vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end

