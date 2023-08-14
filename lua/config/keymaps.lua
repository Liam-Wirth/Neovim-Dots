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
    opts.remap = not M.is_vscode
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

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- redundantsave file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- open lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

--TODO: what this do 
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
--easy tab navidation
map("n", "<leader><tab>1", "1gt",{ desc = "First Tab"})
map("n", "<C-1>", "1gt",{ desc = "First Tab"})

map("n", "<leader><tab>2", "2gt",{ desc = "Second Tab"})
map("n", "<C-2>", "2gt",{ desc = "Second Tab"})

map("n", "<leader><tab>3", "<cmd>3gt<cr>",{ desc = "Third Tab"})
map("n", "<C-3>", "<cmd>3gt<cr>",{ desc = "Third Tab"})

map("n", "<leader><tab>4", "<cmd>4gt<cr>",{ desc = "Fourth Tab"})
map("n", "<C-4>", "<cmd>4gt<cr>",{ desc = "Fourth Tab"})

map("n", "<leader><tab>5", "<cmd>5gt<cr>",{ desc = "Fifth Tab"})
map("n", "<C-5>", "<cmd>5gt<cr>",{ desc = "Fifth Tab"})

map("n", "<leader><tab>6", "<cmd>6gt<cr>",{ desc = "Sixth Tab"})
map("n", "<C-6>", "<cmd>6gt<cr>",{ desc = "Sixth Tab"})

map("n", "<leader><tab>7", "<cmd>7gt<cr>",{ desc = "Seventh Tab"})
map("n", "<C-7>", "<cmd>7gt<cr>",{ desc = "Seventh Tab"})

map("n", "<leader><tab>8", "<cmd>8gt<cr>",{ desc = "Eighth Tab"})
map("n", "<C-8>", "<cmd>8gt<cr>",{ desc = "Eigth Tab"})

map("n", "<leader><tab>9", "<cmd>9gt<cr>",{ desc = "Ninth Tab"})
map("n", "<C-9>", "<cmd>9gt<cr>",{ desc = "Ninth Tab"})

map("n", "<leader><tab>0", "<cmd>10gt<cr>",{ desc = "Tenth Tab"})
map("n", "<C-0>", "<cmd>10gt<cr>",{ desc = "Tenth Tab"})
--TODO might be cool to make a specific keybinding here that when pressed pulls up a little window in which you can type the number of the tab you want to go to. but that's a super fringe case IMO
return M