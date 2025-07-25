if not vim.g.vscode then
   local Util = require("util")
   return {
      "nvim-telescope/telescope.nvim",
      commit = vim.fn.has("nvim-0.9.0") == 0 and "057ee0f8783" or nil,
      cmd = "Telescope",
      lazy = true,
      version = false, -- telescope did only one release, so use HEAD for now
      keys = {
         { "<leader>,",       "<cmd>Telescope buffers show_all_buffers=true<cr>",   desc = "Switch Buffer" },
         { "<leader>/",       Util.telescope("live_grep"),                          desc = "Grep (root dir)" },
         { "<leader>:",       "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
         { "<leader><space>", Util.telescope("files"),                              desc = "Find Files (root dir)" }, -- find
         { "<leader>fb",      "<cmd>Telescope buffers<cr>",                         desc = "Buffers" },
         { "<leader>ff",      Util.telescope("files"),                              desc = "Find Files (root dir)" },
         { "<leader>fF",      Util.telescope("files", { cwd = false }),             desc = "Find Files (cwd)" },
         { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                        desc = "Recent" },
         { "<leader>fR",      Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
         -- git
         { "<leader>gc",      "<cmd>Telescope git_commits<CR>",                     desc = "commits" },
         { "<leader>gs",      "<cmd>Telescope git_status<CR>",                      desc = "status" },
         -- search
         { '<leader>t"',      "<cmd>Telescope registers<cr>",                       desc = "Registers" },
         { "<leader>ta",      "<cmd>Telescope autocommands<cr>",                    desc = "Auto Commands" },
         { "<leader>tb",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",       desc = "Buffer" },
         { "<leader>tc",      "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
         { "<leader>tC",      "<cmd>Telescope commands<cr>",                        desc = "Commands" },
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
               }
            }
         }
      }
   }
end
