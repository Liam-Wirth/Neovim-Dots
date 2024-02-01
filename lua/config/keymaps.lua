local vim = vim
local M = {}
---@ignore
local wk = require("which-key")
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])
--NOTE: this will be helpful later, basically ensuring that if we are in vscode environment (I.E, Vscode-NVIM, remapping will not take place (so as to help not interfere with vscode keybinds))
M.is_vscode = vim.g.vscode
M.defaultOpts = {
   remap = false,
   silent = true,
   desc = nil,
}
function M.map(mode, lhs, rhs, opts)
   --Merge provided options with defaults, ensuring provided opts takes priority over defaults
   opts = vim.tbl_extend("keep", opts or {}, M.defaultOpts)
   opts.remap = not M.is_vscode
   opts.silent = opts.silent ~= false

   -- Register the keybinding with Which-Key
   if vim.fn.exists(":WhichKey") == 2 then
      local wk = require("which-key")
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
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
--map({ "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
--[[
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
--]]
-- redundantsave file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- noh
map({ "v", "n" }, "<leader>h", "<cmd>noh<cr>", { desc = "Clear Highlight" })
--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- open lazy
map("n", "<leader>el", "<cmd>Lazy<cr>", { desc = "Lazy" })

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
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>BufferLineMoveNext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>BufferLine<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>BufferLineMovePrev<cr>", { desc = "Previous Tab" })

map("n", "<leader>et", "<cmd>Neotree<cr>", { desc = "Toggle Filetree" })
map("n", "<leader>eu", "<cmd>lua require('undotree').toggle() <cr>", { desc = "Toggle Visual undotree" })
map("n", "<leader>ea", "<cmd> AerialToggle <cr>", { desc = "Toggle Aerial (File overview)" })

map('n', '<leader>be', vim.diagnostic.open_float, { desc = "Open Float", remap = true, silent = true })
map('n', '<leader>b[', vim.diagnostic.goto_prev, { desc = "Go to next Diagnostic", remap = true, silent = true })
map('n', '<leader>b]', vim.diagnostic.goto_next, { desc = "go to previous diagnostic", remap = true, silent = true })
map('n', '<leader>bq', vim.diagnostic.setloclist, { desc = "Set Local List", remap = true, silent = true })
vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
vim.keymap.set("n", "g<C-a>", require("dial.map").inc_gnormal(), { noremap = true })
vim.keymap.set("n", "g<C-x>", require("dial.map").dec_gnormal(), { noremap = true })
vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), { noremap = true })
vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), { noremap = true })
--TODO might be cool to make a specific keybinding here that when pressed pulls up a little window in which you can type the number of the tab you want to go to. but that's a super fringe case IMO

--GIT:
vim.keymap.set('n', '<leader>gco', '<Plug>(git-conflict-ours)')
vim.keymap.set('n', '<leader>gct', '<Plug>(git-conflict-theirs)')
vim.keymap.set('n', '<leader>gcb', '<Plug>(git-conflict-both)')
vim.keymap.set('n', '<leader>gc0', '<Plug>(git-conflict-none)')
vim.keymap.set('n', '<leader>gc]', '<Plug>(git-conflict-prev-conflict)')
vim.keymap.set('n', '<leader>gc[', '<Plug>(git-conflict-next-conflict)')
--FIX: For some reason these aren't actually getting loaded /setup for which key :(
wk.register({
   g = { name = "Git",
      c = {
      name = "Conflict",
         o = {name = "Our conflicts"},
         t = {name = "Their conflicts"},
         b = {name = "Both"},
      --'0'= {name = "None"},
       --  ']' = {name = "Next Conflict"},
        --  '[' = {name = "Previous Conflict"},
   },
   },
   

   c = { name = "Config" },
   f = { name = "Find" },
   q = { name = "Session Management" },
   s = { name = "Dismiss Notifications" },
   w = { name = "Window Management" },
   b = { name = "[LSP] Buffer Stuff" },
   Tab = { name = "Tab Navigation" },
   e = { name = "Open Auxiliary Windows" },
   r = { name = "Rename"},
   t = { name = "Telescope"},
   o = { name = "Org Mode"},
   x = { name = "ToggleTerm and list"}
}, { prefix = "<leader>", noremap = true })


return M

