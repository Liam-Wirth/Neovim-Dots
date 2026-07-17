-- TODO: Configure so that lsp uses this
if not vim.g.vscode then
   return {
      -- Declarative formatter installs (mason-lspconfig only covers LSP servers).
      -- gofmt/rustfmt/mix/prisma-fmt ship with their toolchains, not Mason.
      {
         "WhoIsSethDaniel/mason-tool-installer.nvim",
         event = "VeryLazy",
         dependencies = { "mason-org/mason.nvim" },
         opts = {
            ensure_installed = {
               "stylua",
               "black",
               "clang-format",
               "prettier",
               "biome",
            },
         },
      },
      {
      "stevearc/conform.nvim",
      event = { "BufWritePre" },
      cmd = { "ConformInfo" },
      config = function()
         local conform = require("conform")
         conform.setup({
            formatters_by_ft = {
               c = { "clang_format" },
               cpp = { "clang_format" },
               css = { "prettier" },
               elixir = { "mix" },
               go = { "gofmt" },
               graphql = { "prettier" },
               javascript = { "biome" },
               json = { "prettier" },
               lua = { "stylua" },
               php = { "prettier" },
               prisma = { "prisma-fmt" },
               python = { "black" },
               rust = { "rustfmt" },
               scss = { "prettier" },
               sql = { "sql_formatter" },
               svelte = { "prettier" },
               typescript = { "biome" },
               vue = { "prettier" },
               yaml = { "prettier" },
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
                  },
               },
               black = {
                  prepend_args = {},
               },
               biome = {
                  prepend_args = {
                     "format",
                  },
               },
            },
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

         vim.api.nvim_create_user_command("Format", function()
            conform.format({ timeout_ms = 500, lsp_fallback = true })
         end, { desc = "Format current buffer" })
      end,
      },
   }
end
