local vim = vim;
local M = {}
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])
  --NOTE: this will be helpful later, basically ensuring that if we are in vscode environment (I.E, Vscode-NVIM, remapping will not take place (so as to help not interfere with vscode keybinds))
 M.is_vscode = vim.g.vscode;
 M.defaultOpts = {
    remap = false,
    silent = true,
    desc = nil,
  }
 function M.map(mode, lhs, rhs, opts)
   --Merge provided options with defaults, ensuring provided opts takes priority over defaults
    opts = vim.tbl_extend('keep', opts or {}, M.defaultOpts)
    opts.remap = ~M.is_vscode
    opts.silent = opts.silent ~= false
  
    -- Register the keybinding with Which-Key
    if vim.fn.exists(':WhichKey') == 2 then
      local wk = require('which-key')
      wk.register({
        [lhs] = { rhs, opts.desc },
      }, {
        mode = mode,
      })
    end
  
    -- Perform the remapping if opts.remap is truthy
    if opts.remap then
      vim.keymap.set(mode, lhs, rhs, opts)
    end
  end
  local map = M.map
 -- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

return M
