<<<<<<< HEAD
require("nvim-treesitter.configs").setup({
 -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
})
=======
return {
   {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      version = false, -- last release is way too old and doesn't work on Windows
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
         {
            "nvim-treesitter/nvim-treesitter-textobjects",
            init = function()
               -- disable rtp plugin, as we only need its queries for mini.ai
               -- In case other textobject modules are enabled, we will load them
               -- once nvim-treesitter is loaded
               require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
               load_textobjects = true
            end,
         },
      },
      cmd = { "TSUpdateSync" },
      keys = {
         { "<c-space>", desc = "Increment selection" },
         { "<bs>",      desc = "Decrement selection", mode = "x" },
      },
      ---@type TSConfig
      opts = {
         highlight = { enable = true, additional_vim_regex_highlighting = false, },
         indent = { enable = true },
         ensure_installed = {
            "bash",
            "c",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "python",
            "query",
            "regex",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
         },
         incremental_selection = {
            enable = true,
            keymaps = {
               init_selection = "<C-space>",
               node_incremental = "<C-space>",
               scope_incremental = false,
               node_decremental = "<bs>",
            },
         },
      },
      ---@param opts TSConfig
      config = function(_, opts)
         if type(opts.ensure_installed) == "table" then
            ---@type table<string, boolean>
            local added = {}
            opts.ensure_installed = vim.tbl_filter(function(lang)
               if added[lang] then
                  return false
               end
               added[lang] = true
               return true
            end, opts.ensure_installed)
         end
         require("nvim-treesitter.configs").setup(opts)

         if load_textobjects then
            -- PERF: no need to load the plugin, if we only need its queries for mini.ai
            if opts.textobjects then
               for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                  if opts.textobjects[mod] and opts.textobjects[mod].enable then
                     local Loader = require("lazy.core.loader")
                     Loader.disabled_rtp_plugins["nvim-treesitter-textobjects"] = nil
                     local plugin = require("lazy.core.config").plugins["nvim-treesitter-textobjects"]
                     require("lazy.core.loader").source_runtime(plugin.dir, "plugin")
                     break
                  end
               end
            end
         end
      end,
   },
   {
      "nvim-treesitter/nvim-treesitter-textobjects",
       lazy = true,
      event = {"BufNewFile", "BufReadPost"},
      init = function()
         -- disable rtp plugin, as we only need its queries for mini.ai
         -- In case other textobject modules are enabled, we will load them
         -- once nvim-treesitter is loaded
         require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
         load_textobjects = true
      end,
   },
   {
     -- "nvim-treesitter/nvim-treesitter-context",
     -- lazy = true,
     -- event = { "BufReadPost", "BufNewFile" },
   }
}
>>>>>>> refactor
