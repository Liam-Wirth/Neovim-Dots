local ret = {
   {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      config = function()
         vim.g.startuptime_tries = 10
      end,
   },
   -- library used by other plugins
   { "nvim-lua/plenary.nvim", lazy = true },
   {
      'andweeb/presence.nvim',
      lazy = false,
      cond = function()
         -- if we are in WSL or just plain windows, don't load this plugin
         return os.getenv("WSL_DISTRO_NAME") == nil -- will eval true if and only if we are not in WSL (hopefully)
      end,
      opts = {
         -- General options
         auto_update         = true,                                             -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
         neovim_image_text   = "that one text editor that LOSERS use! HAHAHAHA", -- Text displayed when hovered over the Neovim image
         main_image          = "neovim",                                         -- Main image display (either "neovim" or "file")
         client_id           = "793271441293967371",                             -- Use your own Discord application client id (not recommended)
         log_level           = nil,                                              -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
         debounce_timeout    = 10,                                               -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
         enable_line_number  = false,                                            -- Displays the current line number instead of the current project
         blacklist           = {},                                               -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
         buttons             = true,                                             -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
         file_assets         = {},                                               -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
         show_time           = true,                                             -- Show the timer

         -- Rich Presence text options
         editing_text        = "Editing a file",       -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
         file_explorer_text  = "Browsing files",       -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
         git_commit_text     = "Committing changes",   -- Format string rendered when committing changes in git (either string or function(filename: string): string)
         plugin_manager_text = "Managing plugins",     -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
         reading_text        = "Reading",              -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
         workspace_text      = "Working on a project", -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
         line_number_text    = "Line %s out of %s",    -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
      }
   },
   -- TODO: Setup a copilot section with keybinds and stuff, I want it disabled by DEFAULT and stuff
}

if vim.g.worklaptop == false then
   table.insert(ret, 
   {
      "CopilotC-Nvim/CopilotChat.nvim",
      branch = "canary",
      dependencies = {
         { "github/copilot.vim" }, -- or github/copilot.vim
         { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
         debug = true, -- Enable debugging
         -- See Configuration section for rest
      },
   }
   )
   table.insert(ret, {
      
      'github/copilot.vim',
      lazy = true,
      event = { "BufReadPre", "BufNewFile", "BufEnter" },
      config = function()
         -- configure the plugin here
         vim.g.copilot_enabled = 0 -- disable Copilot by default
         require("which-key").add({
            {
               "<leader>ec",
               function()
                  if vim.g.copilot_enabled == 1 then
                     vim.g.copilot_enabled = 0
                     vim.notify("Copilot Disabled")
                  else
                     vim.g.copilot_enabled = 1
                     vim.notify("Copilot Enabled")
                  end
               end,
               desc = "Toggle Copilot"
            }
         })
         vim.keymap.set("n", "<leader>cp", function()

         end)
      end
   })
   table.insert(ret, 
   { 'wakatime/vim-wakatime', lazy = false }
   )
end


return ret
