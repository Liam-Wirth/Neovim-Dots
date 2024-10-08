--again, credit to the lazyvim people for the way they implemented the telescope stuff, super smart guys
local Util = require("util")

return {
   -- search/replace in multiple files
   {
      lazy = true,
      "nvim-pack/nvim-spectre",
      cmd = "Spectre",
      opts = { open_cmd = "noswapfile vnew" },
      -- stylua: ignore
      keys = {
         { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
      },
   },
   -- fuzzy finder
   {
      "nvim-telescope/telescope.nvim",
      commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
      cmd = "Telescope",
      lazy = true,
      version = false, -- telescope did only one release, so use HEAD for now
      keys = {
         { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
         { "<leader>/", Util.telescope("live_grep"),                        desc = "Grep (root dir)" },
         { "<leader>:", "<cmd>Telescope command_history<cr>",               desc = "Command History" },
         {
            "<leader><space>",
            Util.telescope("files"),
            desc =
            "Find Files (root dir)"
         },
         -- find
         { "<leader>fb", "<cmd>Telescope buffers<cr>",                         desc = "Buffers" },
         {
            "<leader>ff",
            Util.telescope("files"),
            desc =
            "Find Files (root dir)"
         },
         {
            "<leader>fF",
            Util.telescope("files", { cwd = false }),
            desc =
            "Find Files (cwd)"
         },
         { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                        desc = "Recent" },
         { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
         -- git
         { "<leader>gc", "<cmd>Telescope git_commits<CR>",                     desc = "commits" },
         { "<leader>gs", "<cmd>Telescope git_status<CR>",                      desc = "status" },
         -- search
         { '<leader>t"', "<cmd>Telescope registers<cr>",                       desc = "Registers" },
         { "<leader>ta", "<cmd>Telescope autocommands<cr>",                    desc = "Auto Commands" },
         { "<leader>tb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",       desc = "Buffer" },
         { "<leader>tc", "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
         { "<leader>tC", "<cmd>Telescope commands<cr>",                        desc = "Commands" },
         {
            "<leader>td",
            "<cmd>Telescope diagnostics bufnr=0<cr>",
            desc =
            "Document diagnostics"
         },
         {
            "<leader>tD",
            "<cmd>Telescope diagnostics<cr>",
            desc =
            "Workspace diagnostics"
         },
         { "<leader>tg", Util.telescope("live_grep"),                  desc = "Grep (root dir)" },
         { "<leader>tG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
         { "<leader>th", "<cmd>Telescope help_tags<cr>",               desc = "Help Pages" },
         {
            "<leader>tH",
            "<cmd>Telescope highlights<cr>",
            desc =
            "Search Highlight Groups"
         },
         { "<leader>tk", "<cmd>Telescope keymaps<cr>",                                      desc = "Key Maps" },
         { "<leader>tM", "<cmd>Telescope man_pages<cr>",                                    desc = "Man Pages" },
         { "<leader>tm", "<cmd>Telescope marks<cr>",                                        desc = "Jump to Mark" },
         { "<leader>to", "<cmd>Telescope vim_options<cr>",                                  desc = "Options" },
         { "<leader>tR", "<cmd>Telescope resume<cr>",                                       desc = "Resume" },
         { "<leader>tw", Util.telescope("grep_string", { word_match = "-w" }),              desc = "Word (root dir)" },
         { "<leader>tW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
         {
            "<leader>tw",
            Util.telescope("grep_string"),
            mode = "v",
            desc =
            "Selection (root dir)"
         },
         {
            "<leader>tW",
            Util.telescope("grep_string", { cwd = false }),
            mode = "v",
            desc =
            "Selection (cwd)"
         },
         {
            "<leader>ts",
            "<cmd>SearchSession<cr>",
            mode = { "v", "n" },
            desc =
            "Search Sessions"
         },
         {
            "<leader>ss",
            Util.telescope("lsp_document_symbols", {
               symbols = {
                  "Class",
                  "Function",
                  "Method",
                  "Constructor",
                  "Interface",
                  "Module",
                  "Struct",
                  "Trait",
                  "Field",
                  "Property",
               },
            }),
            desc = "Goto Symbol",
         },
         {
            "<leader>sS",
            Util.telescope("lsp_dynamic_workspace_symbols", {
               symbols = {
                  "Class",
                  "Function",
                  "Method",
                  "Constructor",
                  "Interface",
                  "Module",
                  "Struct",
                  "Trait",
                  "Field",
                  "Property",
               },
            }),
            desc = "Goto Symbol (Workspace)",
         },
      },
      opts = {
         defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
               i = {
                  ["<c-t>"] = function(...)
                     return require("trouble.providers.telescope").open_with_trouble(...)
                  end,
                  ["<a-t>"] = function(...)
                     return require("trouble.providers.telescope").open_selected_with_trouble(...)
                  end,
                  ["<a-i>"] = function()
                     local action_state = require("telescope.actions.state")
                     local line = action_state.get_current_line()
                     Util.telescope("find_files", { no_ignore = true, default_text = line })()
                  end,
                  ["<a-h>"] = function()
                     local action_state = require("telescope.actions.state")
                     local line = action_state.get_current_line()
                     Util.telescope("find_files", { hidden = true, default_text = line })()
                  end,
                  ["<C-Down>"] = function(...)
                     return require("telescope.actions").cycle_history_next(...)
                  end,
                  ["<C-Up>"] = function(...)
                     return require("telescope.actions").cycle_history_prev(...)
                  end,
                  ["<C-f>"] = function(...)
                     return require("telescope.actions").preview_scrolling_down(...)
                  end,
                  ["<C-b>"] = function(...)
                     return require("telescope.actions").preview_scrolling_up(...)
                  end,
               },
               n = {
                  ["q"] = function(...)
                     return require("telescope.actions").close(...)
                  end,
               },
            },
         },
      },
   },
   --TODO fix this
   -- git signs highlights text that has changed since the list
   -- git commit, and also lets you interactively stage & unstage
   -- hunks in a commit.
   {
      "lewis6991/gitsigns.nvim",
      lazy = true,
      event = { "BufReadPre", "BufNewFile", "BufEnter" },
      opts = {
         signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
         },
         on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
               vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            -- stylua: ignore start
            map("n", "]h", gs.next_hunk, "Next Hunk")
            map("n", "[h", gs.prev_hunk, "Prev Hunk")
            map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
            map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
            map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
            map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
            map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
            map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
            map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
            map("n", "<leader>ghd", gs.diffthis, "Diff This")
            map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
         end,
      },
   },
   {
      "RRethy/vim-illuminate",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         delay = 200,
         large_file_cutoff = 2000,
         large_file_overrides = {
            providers = { "lsp" },
         },
      },
      config = function(_, opts)
         require("illuminate").configure(opts)

         local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
               require("illuminate")["goto_" .. dir .. "_reference"](false)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
         end

         map("]]", "next")
         map("[[", "prev")

         -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
         vim.api.nvim_create_autocmd("FileType", {
            callback = function()
               local buffer = vim.api.nvim_get_current_buf()
               map("]]", "next", buffer)
               map("[[", "prev", buffer)
            end,
         })
      end,
      keys = {
         { "]]", desc = "Next Reference" },
         { "[[", desc = "Prev Reference" },
      },
   },
   {
      'akinsho/toggleterm.nvim',
      version = "*",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      keys = {
         vim.keymap.set("n", "<Leader>xf", '<Cmd>execute v:count . "ToggleTerm direction=float"<CR>', { silent = true }),
         vim.keymap.set("n", "<Leader>xh", '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
            { silent = true }),
         vim.keymap.set("n", "<Leader>xv", '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
            { silent = true }),
         vim.keymap.set("n", "<Leader>xt", '<Cmd>execute v:count . "ToggleTerm direction=tab"<CR>', { silent = true }),
         vim.keymap.set("n", "<Leader>xb", "<Cmd>term<CR><Cmd>setlocal nonu nornu<CR>i", { silent = true }),
      },
      opts = {
         open_mapping = "<Leader>xh",
         insert_mappings = false,
         shade_terminals = false,
         size = function(term)
            if term.direction == "horizontal" then
               return vim.o.lines * 0.3
            elseif term.direction == "vertical" then
               return vim.o.columns * 0.5
            end
         end,
         highlights = {
            FloatBorder = {
               link = "FloatBorder",
            },
         },
      }
   },
   {
      'norcalli/nvim-colorizer.lua',
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      config = function()
         require 'colorizer'.setup({
            'css',
            'javascript',
            html = { mode = 'background' },
         }, { mode = 'foreground' })
      end
   },
}
