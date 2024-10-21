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

-- TODO: use icons with these
wk.add({
  -- Basic key mappings
  { "<Esc>", "<C-\\><C-n>", desc = "Escape terminal mode", mode = "t" },

  -- Better up/down
  { "j", "v:count == 0 ? 'gj' : 'j'", desc = "Better down movement", mode = { "n", "x" }, expr = true, silent = true },
  { "k", "v:count == 0 ? 'gk' : 'k'", desc = "Better up movement", mode = { "n", "x" }, expr = true, silent = true },

  -- Move to window using <ctrl> hjkl keys
  { "<C-h>", "<C-w>h", desc = "Go to left window", mode = "n", remap = true },
  { "<C-j>", "<C-w>j", desc = "Go to lower window", mode = "n", remap = true },
  { "<C-k>", "<C-w>k", desc = "Go to upper window", mode = "n", remap = true },
  { "<C-l>", "<C-w>l", desc = "Go to right window", mode = "n", remap = true },

  -- Resize window using <ctrl> arrow keys
  { "<C-Up>", "<cmd>resize +2<cr>", desc = "Increase window height", mode = "n" },
  { "<C-Down>", "<cmd>resize -2<cr>", desc = "Decrease window height", mode = "n" },
  { "<C-Left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width", mode = "n" },
  { "<C-Right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width", mode = "n" },

  -- Move Lines
  { "<A-j>", "<cmd>m .+1<cr>==", desc = "Move down", mode = "n" },
  { "<A-k>", "<cmd>m .-2<cr>==", desc = "Move up", mode = "n" },
  { "<A-j>", ":m '>+1<cr>gv=gv", desc = "Move down", mode = "v" },
  { "<A-k>", ":m '<-2<cr>gv=gv", desc = "Move up", mode = "v" },

  -- Clear search with <esc>
  { "<esc>", "<cmd>noh<cr><esc>", desc = "Escape and clear hlsearch", mode = "n" },

  -- Search word under cursor
  { "gw", "*N", desc = "Search word under cursor", mode = { "n", "x" } },

  -- Better search result navigation
  { "n", "'Nn'[v:searchforward]", desc = "Next search result", mode = { "n", "x", "o" }, expr = true },
  { "N", "'nN'[v:searchforward]", desc = "Prev search result", mode = { "n", "x", "o" }, expr = true },

  -- Save file
  { "<C-s>", "<cmd>w<cr><esc>", desc = "Save file", mode = { "i", "v", "n", "s" } },

  -- Clear highlight
  { "<leader>h", "<cmd>noh<cr>", desc = "Clear Highlight", mode = { "v", "n" } },

  -- Keywordprg
  { "<leader>K", "<cmd>norm! K<cr>", desc = "Keywordprg", mode = "n" },

  -- Better indenting
  { "<", "<gv", desc = "Indent left", mode = "v" },
  { ">", ">gv", desc = "Indent right", mode = "v" },

  -- Open lazy.nvim
  { "<leader>el", "<cmd>Lazy<cr>", desc = "Open Lazy", mode = "n" },

  -- New file
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File", mode = "n" },

  -- Location and Quickfix List
  { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List", mode = "n" },
  { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List", mode = "n" },

  -- Quit all
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit all", mode = "n" },

  -- Window management
  { "<leader>ww", "<C-W>p", desc = "Other window", mode = "n", remap = true },
  { "<leader>wd", "<C-W>c", desc = "Delete window", mode = "n", remap = true },
  { "<leader>w-", "<C-W>s", desc = "Split window below", mode = "n", remap = true },
  { "<leader>w|", "<C-W>v", desc = "Split window right", mode = "n", remap = true },
  { "<leader>-", "<C-W>s", desc = "Split window below", mode = "n", remap = true },
  { "<leader>|", "<C-W>v", desc = "Split window right", mode = "n", remap = true },

  -- Tab management
  { "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New Tab", mode = "n" },
  { "<leader><tab>]", "<cmd>BufferLineMoveNext<cr>", desc = "Next Tab", mode = "n" },
  { "<leader><tab>d", "<cmd>BufferLine<cr>", desc = "Close Tab", mode = "n" },
  { "<leader><tab>[", "<cmd>BufferLineMovePrev<cr>", desc = "Previous Tab", mode = "n" },

  -- Auxiliary windows
  -- { "<leader>et", "<cmd>Neotree<cr>", desc = "Toggle Filetree", mode = "n" },
  { "<leader>ee", "<cmd>TroubleToggle<cr>", desc = "Open/Close Trouble", mode = "n" },
  { "<leader>eu", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle Visual undotree", mode = "n" },
  { "<leader>ea", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial (File overview)", mode = "n" },

  -- Diagnostic
  { "<leader>be", vim.diagnostic.open_float, desc = "Open Float", mode = "n", remap = true, silent = true },
  { "<leader>b[", vim.diagnostic.goto_prev, desc = "Go to previous Diagnostic", mode = "n", remap = true, silent = true },
  { "<leader>b]", vim.diagnostic.goto_next, desc = "Go to next Diagnostic", mode = "n", remap = true, silent = true },
  { "<leader>bq", vim.diagnostic.setloclist, desc = "Set Local List", mode = "n", remap = true, silent = true },

  -- Dial
  { "<C-a>", require("dial.map").inc_normal(), desc = "Increment", mode = "n", noremap = true },
  { "<C-x>", require("dial.map").dec_normal(), desc = "Decrement", mode = "n", noremap = true },
  { "g<C-a>", require("dial.map").inc_gnormal(), desc = "Increment", mode = "n", noremap = true },
  { "g<C-x>", require("dial.map").dec_gnormal(), desc = "Decrement", mode = "n", noremap = true },
  { "<C-a>", require("dial.map").inc_visual(), desc = "Increment", mode = "v", noremap = true },
  { "<C-x>", require("dial.map").dec_visual(), desc = "Decrement", mode = "v", noremap = true },
  { "g<C-a>", require("dial.map").inc_gvisual(), desc = "Increment", mode = "v", noremap = true },
  { "g<C-x>", require("dial.map").dec_gvisual(), desc = "Decrement", mode = "v", noremap = true },

  -- Git
  { "<leader>g", group = "Git" },

  -- Telescope
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },

})

wk.add({
  { "<leader>g", group = "Git" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true },
  { "<leader>w", group = "Window Management", proxy = "<c-w>" },
  { "<leader>b", group = "Buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  { "<leader>c", group = "Config" },
  { "<leader>q", group = "Session Management" },
  { "<leader>s", group = "Dismiss Notifications" },
  { "<leader><tab>", group = "Tab Navigation" },
  { "<leader>e", group = "Open Auxiliary Windows" },
  { "<leader>r", group = "Rename" },
  { "<leader>t", group = "Telescope" },
  { "<leader>o", group = "Org Mode" },
  { "<leader>x", group = "ToggleTerm and list" },
  { "<leader>d", group = "Debug" },
  { "<leader>f", group = "Telescope/Find" },
}, { prefix = "<leader>", noremap = true })
return M
