-- nvim-treesitter MAIN branch (required for Neovim 0.11+/0.12).
-- The old `master` branch is frozen and crashes on 0.12's quantified-match
-- directive API (e.g. markdown injection -> docstring hover). Main has no
-- `nvim-treesitter.configs` module: parsers are installed via install() and
-- highlighting/indent are enabled per-buffer in a FileType autocmd below.
local ret = {
   {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      build = ":TSUpdate",
      lazy = false, -- must load at startup so the FileType autocmd is registered before files open
      config = function()
         local ts = require("nvim-treesitter")

         -- Install parsers (async; no-op for ones already present).
         ts.install({
            "bash", "c", "html", "java", "javascript", "jsdoc", "json", "lua", "luadoc", "luap",
            "markdown", "markdown_inline", "python", "query", "regex", "tsx", "typescript",
            "vim", "vimdoc", "yaml",
         })

         -- Main branch has no highlight/indent modules -- start them per buffer.
         local function enable(buf)
            local ft = vim.bo[buf].filetype
            -- latex highlighting was disabled under the old config; skip empty ft too.
            if ft == "" or ft == "latex" then
               return
            end
            -- Start TS highlighting only if a parser exists for this buffer.
            if not pcall(vim.treesitter.start, buf) then
               return
            end
            -- org kept vim regex highlighting alongside TS
            -- (was: additional_vim_regex_highlighting = { "org" }).
            if ft == "org" then
               vim.bo[buf].syntax = "ON"
            end
            -- TS-based indentation (experimental on main; delete this line if it misbehaves).
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
         end

         vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("nvim_treesitter_start", { clear = true }),
            callback = function(ev) enable(ev.buf) end,
         })

         -- Catch buffers already loaded before this ran (startup / session restore):
         -- their FileType fired before the autocmd existed, so highlighting never
         -- attached. This is what made comments/jsdoc go flat on a reopened session.
         for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
               enable(buf)
            end
         end
      end,
   },
   {
      -- Main branch of textobjects. Not configured yet (matches the prior state,
      -- where no `textobjects` block was set). When you want it, call
      -- require("nvim-treesitter-textobjects").setup{} and define select/move keymaps here.
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      lazy = true,
      event = { "BufNewFile", "BufReadPost" },
   },
   {
      -- Uses core vim.treesitter, so unaffected by the master -> main move.
      "nvim-treesitter/nvim-treesitter-context",
      lazy = true,
      event = { "BufReadPost", "BufNewFile" },
      opts = {
         enable = true,
         max_lines = 3, -- How many lines of context to show
         min_window_height = 0,
         line_numbers = true,
         multiline_threshold = 1,
         trim_scope = "outer", -- Remove leading/trailing whitespace
         mode = "cursor",      -- Line used to calculate context. 'cursor' or 'topline'
         separator = nil,      -- Separator between context and content
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

-- NOTE: incremental_selection (<C-space> / <bs>) was removed -- main branch has
-- no built-in for it. Ask if you want a small replacement wired up.

if not vim.g.vscode then
   return ret
else
   return {}
end
