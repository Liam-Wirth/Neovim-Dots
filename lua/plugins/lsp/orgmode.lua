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
         -- Setup treesitter for org files
         require("nvim-treesitter.configs").setup({
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = { "org" },
            },
            ensure_installed = { "org" },
         })

         require("orgmode").setup({
            org_agenda_files = {
               "~/org/roam/daily/**/*",
               "~/org/roam/agenda/**/*",
               "~/org/**/*"
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

            -- Enable agenda
            org_agenda_files = {
               "~/org/roam/daily",
               "~/org/roam/agenda",
               "~/.config/nvim"
            },
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
         wk.register({
            f = { function() require("org-roam").node.find() end, "Find org-roam node" },
            i = { function() require("org-roam").node.insert() end, "Insert org-roam node" },
            c = { function() require("org-roam").capture.capture() end, "Org-roam capture" },
            b = { function() require("org-roam").buffer.toggle() end, "Toggle org-roam buffer" },
            d = {
               name = "Dailies",
               t = { function() require("org-roam").dailies.today() end, "Today's daily note" },
               y = { function() require("org-roam").dailies.yesterday() end, "Yesterday's daily note" },
               T = { function() require("org-roam").dailies.tomorrow() end, "Tomorrow's daily note" },
            },
            s = { function() require("org-roam").capture.capture({ template = "stub" }) end, "Create org-roam stub" },
            x = { function() require("org-roam").extract.subtree() end, "Extract subtree to new node" },
         }, { prefix = "<leader>nr" })
      end
   }
}
