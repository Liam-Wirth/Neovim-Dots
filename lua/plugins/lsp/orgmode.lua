return {
   {
      "nvim-orgmode/orgmode",
      lazy = true,
      dependencies = {
         { "nvim-treesitter/nvim-treesitter", lazy = true },
         { "akinsho/org-bullets.nvim",        lazy = true },
      },
      ft = { "org" },
      config = function()
         require("orgmode").setup({
            -- NOTE: was declared twice (Lua kept only the second); merged 2026-07-17
            org_agenda_files = {
               "~/org/**/*",
               "~/.config/nvim",
            },
            org_default_notes_file = "~/org/refile.org",

            -- Your custom TODO keywords from Emacs
            org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)", "SOMEDAY(s)" },

            -- Custom TODO faces (approximate your Emacs colors)
            org_todo_keyword_faces = {
               TODO = ":foreground #fb4934 :weight bold",      -- org-warning equivalent
               NEXT = ":foreground #fe8019 :weight bold",      -- orange
               WAITING = ":foreground #fabd2f :weight bold",   -- yellow
               CANCELLED = ":foreground #83a598 :weight bold", -- blue with strikethrough
               SOMEDAY = ":foreground #d3869b :weight bold"    -- magenta
            },

            -- Priority settings (matching your A-E setup)
            org_priority_highest = "A",
            org_priority_lowest = "E",
         })
      end,
   },

   -- Org-roam.nvim main plugin
   {
      "chipsenkbeil/org-roam.nvim",
      dependencies = { "nvim-orgmode/orgmode" },
      ft = { "org" },
      config = function()
         local org_roam = require("org-roam")

         org_roam.setup({
            directory = vim.fn.expand("~/org/roam"), -- Matches your org-roam-directory

            -- Database location
            database = {
               path = vim.fn.expand("~/org/roam/org-roam.db")
            },

            capture_templates = {
               default = {
                  template =
                  "#+latex_class: chameleon\n#+export_file_name: ~/org/exported/\n#+author: Liam Wirth\n#+date: %<%Y-%m-%d>\n\n* ${title}\n\n%?",
                  file_name = "%<%Y%m%d%H%M%S>-${slug}.org",
               },
               stub = {
                  template =
                  "#+title: ${title}\n#+filetags: :stub:${tags}:\n#+latex_class: chameleon\n#+export_file_name: ~/org/exported/\n#+author: Liam Wirth\n#+date: %<%Y-%m-%d>\n\n* ${title}\n\n%?",
                  file_name = "%<%Y%m%d%H%M%S>-${slug}.org",
               },
            },
            dailies = {
               directory = "daily",
               capture_templates = {
                  journal = {
                     template =
                     "#+title: %<%Y-%m-%d (%a)>\n#+startup: showall\n#+filetags: :dailies:\n\n* Daily Overview\n\n* [/] Do Today\n\n* [/] Maybe Do Today\n\n* Journal\n** %<%H:%M> %?\n\n* [/] Completed Tasks\n",
                     file_name = "%<%Y-%m-%d>.org"
                  },
                  task = {
                     template = "* [/] Do Today\n** [ ] %?",
                     file_name = "%<%Y-%m-%d>.org",
                     target = "Do Today"
                  }
               }
            },
            completion = {
               enabled = true,
               minimum_length = 2
            },
            backlinks = {
               enabled = true
            },
            unlinked_references = {
               enabled = false
            }
         })
         local wk = require("which-key")
         -- which-key v3 spec (wk.register was removed in v3)
         wk.add({
            { "<leader>nr", group = "Org-roam" },
            { "<leader>nrf", function() require("org-roam").node.find() end, desc = "Find org-roam node" },
            { "<leader>nri", function() require("org-roam").node.insert() end, desc = "Insert org-roam node" },
            { "<leader>nrc", function() require("org-roam").capture.capture() end, desc = "Org-roam capture" },
            { "<leader>nrb", function() require("org-roam").buffer.toggle() end, desc = "Toggle org-roam buffer" },
            { "<leader>nrd", group = "Dailies" },
            { "<leader>nrdt", function() require("org-roam").dailies.today() end, desc = "Today's daily note" },
            { "<leader>nrdy", function() require("org-roam").dailies.yesterday() end, desc = "Yesterday's daily note" },
            { "<leader>nrdT", function() require("org-roam").dailies.tomorrow() end, desc = "Tomorrow's daily note" },
            { "<leader>nrs", function() require("org-roam").capture.capture({ template = "stub" }) end, desc = "Create org-roam stub" },
            { "<leader>nrx", function() require("org-roam").extract.subtree() end, desc = "Extract subtree to new node" },
         })
      end
   }
}
