vim.g.wakatime_log_level = "error" --SHUT UP!!! SHUT UP SHUT UP SHUT UP!!!
vim.env.WAKATIME_LOG_LEVEL = "error"
vim.g.wakatime_cli_path = "/usr/bin/wakatime-cli"
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
      "andweeb/presence.nvim",
      lazy = false,
      cond = function()
         -- if we are in WSL or just plain windows, don't load this plugin
         return os.getenv("WSL_DISTRO_NAME") == nil -- will eval true if and only if we are not in WSL (hopefully)
      end,
      opts = {
         -- General options
         auto_update = true, -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
         neovim_image_text = "that one text editor that LOSERS use! HAHAHAHA", -- Text displayed when hovered over the Neovim image
         main_image = "neovim", -- Main image display (either "neovim" or "file")
         log_level = nil, -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
         debounce_timeout = 10, -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
         enable_line_number = false, -- Displays the current line number instead of the current project
         blacklist = {}, -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
         buttons = true, -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
         file_assets = {}, -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
         show_time = true, -- Show the timer

         -- Rich Presence text options
         editing_text = "Editing a file",
         file_explorer_text = "Browsing files",
         git_commit_text = "Committing changes",
         plugin_manager_text = "Managing plugins",
         reading_text = "Reading",
         workspace_text = "Working on a project",
         line_number_text = "Line %s out of %s",
      },
   },
   {
      "stevearc/oil.nvim",
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
   },
   -- TODO: Setup a copilot section with keybinds and stuff, I want it disabled by DEFAULT and stuff
}

-- NOTE: See (.gitignored/private) file for configuration/setup of internal completions at work
if vim.g.worklaptop == false then
   table.insert(ret, {
      "CopilotC-Nvim/CopilotChat.nvim",
      dependencies = {
         { "github/copilot.vim" }, -- or github/copilot.vim
         { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
      },
      opts = {
         debug = true, -- Enable debugging
      },
   })
   -- Another thing is setup for a separate config. dw about it :)
   table.insert(ret, {
      "github/copilot.vim",
      lazy = true,
      event = { "BufReadPre", "BufNewFile", "BufEnter" },
      config = function()
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
               desc = "Toggle Copilot",
            },
         })
         vim.keymap.set("n", "<leader>cp", function() end)
      end,
   })
   table.insert(ret, {
      "wakatime/vim-wakatime",
      lazy = false,
      opts = {
         debug = false,
         heartbeat_frequency = 5,
      },
   })
end
return ret
