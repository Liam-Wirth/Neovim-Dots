--NOTE: Just learned that function arguments are completely optional in lua.

--NOTE: Check lsp-config/lsp-config.lua for the setup of more keybindings, these ones are buffer specific

local wk = require("which-key")
local pluginlist = require("util.plugins")
--------------Keybinds!
vim.cmd([[vnoremap <c-f> y<ESC>/<c-r>"<CR>]])
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--                    Setup for plugins that don't really need their own file!

--require('Comment').setup({
--TODO: look into the options available for comment.nvim

--TODO:
--HINTS
-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})
-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer]" })

wk.register({
  s = {
    name = "Search",
    f = { "<cmd> Telescope find_files<cr>", "[S]earch [F]iles" },
    w = { "<cmd> Telescope grep_string<cr>", "[S]earch current [W]ord" },
    h = { "<cmd> Telescope help_tags<cr>", "[S]earch [H]elp" },
    g = { "<cmd> Telescope live_grep<cr>", "[S]earch by [G]rep" },
    d = { "<cmd> Telescope diagnostics<cr>", "[S]earch  [D]iagnostics" },
    t = { "<cmd> Telescope todo-comments todo<cr>", "[S]earch current buffer's TODO flags" },
  },
}, { prefix = "<leader>" })
wk.register({
  f = {
    name = "File",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    n = { "cmd>enew<cr>", "New File" },
  },
}, { prefix = "<leader>", noremap = true })
vim.keymap.set("n", "<a-f>", function()
  vim.lsp.buf.format({ async = true })
end)
-------------------------------------------------------------------------------------------------------------
--                                          Org Mode                                                       --
-------------------------------------------------------------------------------------------------------------

wk.register({
  e = {
    name = "Open Auxiliary Windows",
    t = { "<cmd>NvimTreeToggle<cr>", "Toggle Filetree" },
    f = { "<cmd> NvimTreeFocus<cr>", "Focus Filetree" },
    u = { "<cmd>lua require('undotree').toggle() <cr>", "Toggle Visual UndoTree" },
    F = {"<cmd> vim.diagnostic.open_float<cr>", "LSP: Open Float"}
  },
}, { prefix = "<leader>", noremap = true })

--TODO: look into registering this with whichkey? I dunno, not sure about getting my leader to work in visual mode, which is the mode that this keybind applies largely to
vim.cmd([[vnoremap <c-f> y<ESC>/<c-r>"<CR>]])
vim.keymap.set("n", "<Leader>xb", "<Cmd>term<CR><Cmd>setlocal nonu nornu<CR>i", { silent = true })
wk.register({
  x = {
    name = "ToggleTerm",
    f = { '<Cmd>execute v:count . "ToggleTerm direction=float"<CR>', "Floating Terminal" },
    h = { '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>', "Horizontal Terminal" },
    v = { '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>', "Vertical Terminal" },
    t = { '<Cmd>execute v:count . "ToggleTerm direction=tab"<CR>', "Open Terminal in other tab" },
    b = { "<Cmd>term<CR><Cmd>setlocal nonu nornu<CR>i", "I think this just switches to the terminal" },
  },
}, { prefix = "<leader>", noremap = true })
--NOTE: I know this is dumb but I cant really remember how else I map this lole
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])
require("lsp-config.lsp-config")
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
