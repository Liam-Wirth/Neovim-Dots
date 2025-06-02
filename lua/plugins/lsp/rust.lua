local oa = require([[plugins.lsp.lspconfig]]).on_attach
vim.api.nvim_set_hl(0, "RustaceanvimFloat", { bg = "#282828", fg = "#ebdbb2" })       -- Example Gruvbox colors
vim.api.nvim_set_hl(0, "RustaceanvimFloatBorder", { bg = "#282828", fg = "#a89984" }) -- I don't want rustaceanvim to be transparent

return {
   "mrcjkb/rustaceanvim",
   version = "^5", -- Recommended
   lazy = false,   -- This plugin is already lazy
   config = function(_, opts)
      vim.g.rustaceanvim = {
         tools = {
            autoSetHints = true,
            float_win_config = {
               border = "rounded",
               bg = vim.api.nvim_get_hl(0, { name = "RustaceanvimFloat" }).bg,
               fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg,
               winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            }
         },
         -- LSP configuration
         server = {
            on_attach = function(client, bufnr)
               require("which-key").add({
                  { "<leader>r", group = "Rust", desc = "Rust" },
                  {
                     "<leader>rc",
                     function() vim.cmd.RustLsp("openCargo") end,
                     group = "Rust",
                     desc =
                     "Open Cargo.toml"
                  },
                  {
                     "<leader>ba",
                     function() vim.cmd.RustLsp("codeAction") end,
                     remap = true,
                     desc =
                     "Code Action {Rust}"
                  },
                  {
                     "<leader>re",
                     function() vim.cmd.RustLsp("explainError") end,
                     desc =
                     "Explain Error"
                  },
                  {
                     "<leader>rp",
                     function() vim.cmd.RustLsp("parentModule") end,
                     desc =
                     "Parent Module"
                  },
                  {
                     "<leader>ru",
                     function() vim.cmd.Rustc("unpretty", "hir") end,
                     desc =
                     "Parent Module"
                  },
               })
               vim.api.nvim_set_hl(0, "NormalFloat", { link = "RustaceanvimFloat" })
               vim.api.nvim_set_hl(0, "FloatBorder", { link = "RustaceanvimFloatBorder" })
               oa(client, bufnr)    -- NOTE: Hacky but maybe not horrible?
            end,
            default_settings = {
               -- rust-analyzer language server configuration
               ["rust-analyzer"] = {
                  cargo = { allFeatures = true },
                  checkOnSave = {
                     command = "clippy",
                     extraArgs = { "--no-deps" }
                  },
                  diagnostics = {
                  }
               },
            },
         },
         -- DAP configuration
         dap = {
         },

      }
   end,
}
