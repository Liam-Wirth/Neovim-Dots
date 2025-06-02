-- TODO: Configure so that lsp uses this
return {
   "stevearc/conform.nvim",
   event = { "BufWritePre" },
   cmd = { "ConformInfo" },
   config = function()
      local conform = require("conform")

      conform.setup({
         formatters_by_ft = {
            css = { "prettier" },
            elixir = { "mix" },
            go = { "gofmt" },
            graphql = { "prettier" },
            javascript = { "biome" }, -- or "prettier" if you prefer
            json = { "prettier" },
            lua = { "stylua" },
            php = { "prettier" },
            prisma = { "prisma-fmt" },
            python = { "black" },
            rust = { "rustfmt" },
            scss = { "prettier" },
            sql = { "sql_formatter" },
            typescript = { "biome" },
            vue = { "prettier" },
            asm = { "asmfmt" },
         },

         formatters = {
            prettier = {
               prepend_args = {
                  "--single-quote",
                  "--print-width",
                  "80",
               },
            },
            stylua = {
               prepend_args = {
                  "--column-width",
                  "120",
                  "--line-endings",
                  "Unix",
                  "--indent-type",
                  "Spaces",
                  "--indent-width",
                  "3",
                  "--quote-style",
                  "AutoPreferDouble",
               },
            },
            rustfmt = {
               prepend_args = {
                  "--emit=stdout",
                  "--edition=2021",
               },
            },
            black = {
               prepend_args = {},
            },
            biome = {
               -- Your biome settings
               prepend_args = {
                  "format",
               },
            },
         },
         -- For format on key mapping (optional)
         format_after_save = false,
      })

      -- Optional: Add key mappings
      vim.keymap.set({ "n", "v" }, "<leader>.", function()
         conform.format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 500,
         })
      end, { desc = "Format file or range (in visual mode)" })
   end,
}
