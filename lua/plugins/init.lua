vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end
vim.api.nvim_command("packadd packer.nvim")
-- returns the require for use in `config` parameter of packer's use
-- expects the name of the config file
local function get_setup(name)
  return string.format('require("setup/%s")', name)
end

local vim = vim
--TODO: Move all configs to their own respective files
return require("packer").startup(function(use)
  --------------------------------------------------------
  ---                   Meta/Functionality              --
  --------------------------------------------------------
  use({ "nvim-treesitter/nvim-treesitter" })
  use({
    "nvim-orgmode/orgmode",
    config = function()
      require("orgmode").setup({
        require("orgmode").setup_ts_grammar(),
        org_agenda_files = { "~/Documents/Agenda/*", "~/my-orgs/**/*" },
        org_default_notes_file = "~/Documents/org/default.org",
      })
    end,
  })
  use({
    "lewis6991/impatient.nvim", -- Decrease nvim load times
    config = function()
      require("impatient")
    end,
  })
  use("dstein64/vim-startuptime") -- Measure startup time
  use("nvim-lua/popup.nvim") -- Pop up helper
  use("nvim-lua/plenary.nvim") -- Neovim Lua functions
  --Packer
  use("wbthomason/packer.nvim")
  --------------------------------------------------------
  ---                   UI Stuff                        --
  --------------------------------------------------------
  use({
    "simrat39/rust-tools.nvim",
    config = function()
      require("lsp-config.rust-tools")
    end,
  })
  --Nvim-Tree
  use({
    "nvim-tree/nvim-web-devicons", -- optional, for file icons
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("plugins.lookandfeel.nvimtree")
    end,
  })
  --TODO: Get the pretty folds plugin, and then whatever the fold search plugin is
  --telescope
  use("nvim-telescope/telescope.nvim")
  --bufferline
  use({
    "akinsho/bufferline.nvim",
    tag = "v3.*",
    config = function()
      require("plugins.lookandfeel.bufferline")
    end,
  })
  --lualine  -- Fancy status line/tab line
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("plugins.lookandfeel.lualine")
    end,
  })
  --notify
  use({
    --TODO: Fix this, it's yelling at me on startup about something to do with the highlight colors.
    "rcarriga/nvim-notify",
    config = function()
      require("plugins.lookandfeel.notify")
    end,
  })
  --Alpha (my greeter)
  
  use({
    "goolord/alpha-nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("plugins.lookandfeel.alpha")
    end,
  })
  --TODO: swap this out with another one that I understand
  --session manager
  use({
    "Shatur/neovim-session-manager",
    config = function()
      require("plugins.lookandfeel.session-manager")
    end,
  })
  --telescope ui selector for the session manager
  use({ "nvim-telescope/telescope-ui-select.nvim" })
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("plugins.lookandfeel.indentblankline")
    end,
  })
  --ToggleTerm
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("plugins.lookandfeel.toggleterm")
    end,
  })
  --------------------------------------------------------
  ---                   Text Stuff?                     --
  --------------------------------------------------------
  --Highlights the word under the cursor similar to how other editors will
  use({
    "RRethy/vim-illuminate",
    config = function()
      require("plugins.illuminate")
    end,
  })
  use({
    "folke/todo-comments.nvim", -- Todo comment highlighting
    config = function()
      require("todo-comments").setup({
        require("plugins.lookandfeel.todocomments"),
      })
    end,
  })
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        require("plugins.treesitter"),
      })
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter-context", -- Show current context via TreeSitter
    config = function()
      require("treesitter-context").setup({
        pattern = {
          tex = {
            "minted_environment",
          },
        },
      })
    end,
  })
  use("nvim-treesitter/playground")
  --TODO: set this up
  use({
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup({})
    end,
  })
  --Graphical undo tree to make understanding how undo works in vim a little easier
  use({
    "jiaoshijie/undotree",
    config = function()
      require("undotree").setup()
    end,
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })
  -------------------------------------------------------
  --                     Formatting                    --
  -------------------------------------------------------
  --TODO: look into the configuration for this plugin because I kinda just stole this from someone elses cfg
  use({
    "mhartington/formatter.nvim", -- auto reformatter
    config = function()
      require("formatter").setup({
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua(),
          },
          rust = {
            require("formatter.filetypes.rust").rustfmt,
          },
          go = {
            require("formatter.filetypes.go").gofmt,
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      })
    end,
  })
  use("junegunn/vim-easy-align") -- Quickly align around a character
  --lsp-config,mason,dap,linter,and formatters
  use({
    "neovim/nvim-lspconfig",
    config = function()
      require("lsp-config.lsp-config")
    end,
  })
use({ "onsails/lspkind-nvim", module = "lspkind" })
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("mfussenegger/nvim-dap")
  use({
    "jose-elias-alvarez/null-ls.nvim", -- General purpose LSP things
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        debug = false,
        sources = {
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylua,
        },
      })
    end,
    event = "BufRead",
  })
  use({ "nvim-treesitter/nvim-treesitter-textobjects", after = { "nvim-treesitter" } }) -- Additional textobjects for treesitter
  use("tpope/vim-fugitive") -- Git commands in nvim
  use("tpope/vim-rhubarb") -- Fugitive-companion to interact with github
  use("lewis6991/gitsigns.nvim")
  use("mfussenegger/nvim-jdtls")
  use("tpope/vim-sleuth")
  -------SNIPPETS?
  -- Autocompletion plugin
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-calc" },
      { "rafamadriz/friendly-snippets" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-omni" },
    },
    config = function()
      require("cmp")
      require("plugins.nvim-cmp")
    end,
  })
  --Snippets
  use({
    "L3MON4D3/LuaSnip",
    config = function()
      require("plugins.luasnip")
      require("luasnip.loaders.from_vscode").load()
      require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/lua/lspconfig/snippets/" })
    end,
  }) -- Snippets plugin
  -- use({ 'tpope/vim-dadbod' }) -- Database plugin
  -- use({ 'kristijanhusak/vim-dadbod-completion', ft = 'sql' }) -- Database completion
  -- use({ 'kristijanhusak/vim-dadbod-ui', ft = 'sql' }) -- Database UI
  use({
    "Saecki/crates.nvim", -- Completion for Cargo.toml files
    config = function()
      require("crates").setup({})
    end,
  })
  use({
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  })
  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("plugins.lookandfeel.colorizer")
    end,
  })
  use("andweeb/presence.nvim")
  use({
    "folke/which-key.nvim",
    config = function()
      require("plugins.whichkey")
      require("keybinds")
    end,
  })
  -------------------------------------------------------
  --               Misc/Unsorted Plugins               --
  -------------------------------------------------------
  use({ "ellisonleao/gruvbox.nvim" })
  use({
    "NTBBloodbath/doom-one.nvim",
    setup = function()
      --See base init.lua for this
    end,
    config = function() end,
  })
  use({ "wesleimp/stylua.nvim" })
end)

