return {
    {
        'folke/which-key.nvim',
        opts = {},
        event = 'BufReadPost',
    },
    {
        "NTBBloodbath/doom-one.nvim",
        lazy = false,
        init = function()
            vim.g.doom_one_cursor_coloring = true
            vim.g.doom_one_terminal_colors = true
            vim.g.doom_one_italic_comments = true
            vim.g.doom_one_enable_treesitter = true
            vim.g.doom_one_diagnostics_text_color = false
            vim.g.doom_one_transparent_background = false
            vim.g.doom_one_pumblend_enable = false
            vim.g.doom_one_pumblend_transparency = 20
            vim.g.doom_one_plugin_neorg = true
            vim.g.doom_one_plugin_barbar = false
            vim.g.doom_one_plugin_telescope = false
            vim.g.doom_one_plugin_neogit = true
            vim.g.doom_one_plugin_nvim_tree = true
            vim.g.doom_one_plugin_dashboard = true
            vim.g.doom_one_plugin_startify = true
            vim.g.doom_one_plugin_whichkey = true
            vim.g.doom_one_plugin_indent_blankline = true
            vim.g.doom_one_plugin_vim_illuminate = true
            vim.g.doom_one_plugin_lspsaga = false
        end
    },

    -- measure startuptime
    {
      "dstein64/vim-startuptime",
      cmd = "StartupTime",
      config = function()
        vim.g.startuptime_tries = 10
      end,
    },
  
    -- Session management. This saves your session in the background,
    -- keeping track of open buffers, window arrangement, and more.
    -- You can restore sessions when returning through the dashboard.
    {
      "folke/persistence.nvim",
      event = "BufReadPre",
      opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" } },
      -- stylua: ignore
      keys = {
        { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
        { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
        { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
      },
    },
  
    -- library used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },
  }
