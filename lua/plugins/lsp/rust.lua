return {
   {
      'simrat39/rust-tools.nvim',
      lazy = true,
      event = "BufReadPost",
      config = function()
      end,
   },

   {
      'mrcjkb/rustaceanvim',
      version = '^5', -- Recommended
      lazy = false,   -- This plugin is already lazy
      config = function(_, opts)
         vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {
            },
            -- LSP configuration
            server = {
               on_attach = function(client, bufnr)
                  require("which-key").add({
                     { "<leader>r", group = "Rust", desc = "Rust" },
                     {
                        "<leader>rc",
                        function() vim.cmd.RustLsp('openCargo') end,
                        group = "Rust",
                        desc =
                        "Open Cargo.toml"
                     },
                     {
                        "<leader>ba",
                        function() vim.cmd.RustLsp('codeAction') end,
                        remap = true,
                        desc =
                        "Code Action {Rust}"
                     },
                     {
                        "<leader>re",
                        function() vim.cmd.RustLsp('explainError') end,
                        desc =
                        "Explain Error"
                     },
                     {
                        "<leader>rp",
                        function() vim.cmd.RustLsp('parentModule') end,
                        desc =
                        "Parent Module"
                     },
                     {
                        "<leader>ru",
                        function() vim.cmd.Rustc('unpretty', 'hir') end,
                        desc =
                        "Parent Module"
                     },

                  })
               end,
               default_settings = {
                  -- rust-analyzer language server configuration
                  ['rust-analyzer'] = {
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
      end
   },
}
