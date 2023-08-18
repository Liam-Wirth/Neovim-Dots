local ui = require("util.glyphs").ui
return{
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
                                                                             
        ██████   █████                   █████   █████  ███                  
       ░░██████ ░░███                   ░░███   ░░███  ░░░                   
        ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   
        ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  
        ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  
        ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  
        █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ 
       ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ]]
       dashboard.section.header.val = vim.split(logo,"\n")
       
       dashboard.section.buttons.val = {
	dashboard.button("f", ui.FindFile .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", ui.NewFile .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", ui.RecentFiles .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", ui.FindText .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", ui.Config .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", ui.RestoreSession.. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", ui.Lazy .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", ui.Quit .. " Quit", ":qa<CR>"),      
     }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end
      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
	  ---@type string
          local stats = require("lazy").stats()
	  ---@type string
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
	  ---@type string
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  }
