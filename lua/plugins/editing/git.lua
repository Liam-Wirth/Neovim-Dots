return {
-- lazy.nvim
{'akinsho/git-conflict.nvim', version = "*", config = {
      default_mappings = false, --NOTE: defined in keymaps.lua
      default_commands = true,
      disable_diagnostics = false,
      list_opener = 'copen',
highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'DiffAdd',
    current = 'DiffText',
  }
   }},

}
