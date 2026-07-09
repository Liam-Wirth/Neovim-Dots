local ret = {
   {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      branch = "master",
      build = ":TSUpdate",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
         "nvim-treesitter/nvim-treesitter-textobjects",
      },
      cmd = { "TSUpdateSync" },
      keys = {
         { "<c-space>", desc = "Increment selection" },
         { "<bs>",      desc = "Decrement selection", mode = "x" },
      },
      opts = {
         highlight = { enable = true, additional_vim_regex_highlighting = { "org" }, disable = { "latex" }, },
         indent = { enable = true },
         ensure_installed = {
            "bash", "c", "html", "java", "javascript", "jsdoc", "json", "lua", "luadoc", "luap",
            "markdown", "markdown_inline", "org", "python", "query", "regex", "tsx", "typescript",
            "vim", "vimdoc", "yaml",
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
      config = function(_, opts)
         -- Deduplicate ensure_installed
         if type(opts.ensure_installed) == "table" then
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
      end,
   },
   {
      "nvim-treesitter/nvim-treesitter-textobjects",
      lazy = true,
      event = { "BufNewFile", "BufReadPost" },
   },
   {
      "nvim-treesitter/nvim-treesitter-context",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         enable = true,
         max_lines = 3, -- How many lines of context to show
         min_window_height = 0,
         line_numbers = true,
         multiline_threshold = 1,
         trim_scope = 'outer', -- Remove leading/trailing whitespace
         mode = 'cursor', -- Line used to calculate context. 'cursor' or 'topline'
         separator = nil, -- Separator between context and content
         zindex = 20,
      },
      keys = {
         {
            "<leader>tc",
            function()
               require("treesitter-context").toggle()
            end,
            desc = "Toggle Treesitter Context"
         },
      },
   },
}

if not vim.g.vscode then
   return ret
else
   return {}
end
