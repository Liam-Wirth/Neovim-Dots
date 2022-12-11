--NOTE: Just learned that function arguments are completely optional in lua.

local wk = require("which-key")
local pluginlist = require("util.plugins")
local nmap = function(keys, func, desc, plugin, bufnr)
    if desc and plugin then
           desc = plugin..": "..desc
          end

         vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
      end
 --------------Keybinds!
vim.g.maplocalleader = " "

--vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })



--                    Setup for plugins that don't really need their own file!

--require('Comment').setup({
--TODO look into the options available for comment.nvim
--});

--TODO
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
--TODO: move these keybindings to a specific keybindings file
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
        f = {"<cmd> Telescope find_files<cr>","[S]earch [F]iles"},
        w = {"<cmd> Telescope grep_string<cr>","[S]earch current [W]ord"},
        h = {"<cmd> Telescope help_tags<cr>","[S]earch [H]elp"},
        g = {"<cmd> Telescope live_grep<cr>","[S]earch by [G]rep"},
        d = {"<cmd> Telescope diagnostics<cr>","[S]earch  [D]iagnostics"},
    },
}, {prefix = "leader"})
wk.register({
f = {
        name = "File",
          f = { "<cmd>Telescope find_files<cr>", "Find File" },
          r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
          n = { "<cmd>enew<cr>", "New File" },
    },
}, {prefix = "leader",noremap = true})





-------------------------------------------------------------------------------------------------------------
--                                          Org Mode                                                       --
-------------------------------------------------------------------------------------------------------------
wk.register({
})
