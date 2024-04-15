-- NOTE: The error regarding lspconfig being weird and mason servers not loading right might be here
local glyphs = require('util.glyphs')
return {
   {
      "neovim/nvim-lspconfig",
      lazy = false,
   },
   -- lsp-installer | manages installing our lsp servers for us
   {
      'williamboman/mason.nvim',
      dependencies = { 'williamboman/mason-lspconfig.nvim' },
      cmd = "Mason",
      lazy = false,
      keys = { { "<leader>em", "<cmd>Mason<cr>", desc = "Mason" } },
      build = ":MasonUpdate",
      opts = {
         ensure_installed = {
            "stylua",
            "shfmt",
            "lua-language-server",
            "texlab",
            --"latexindent",
            "bibtex-tidy",
            "misspell",
            "svls",
            "verible",
            "cpptools",
            "clang-format",
            "clangd",
            "cpplint",
            "asmfmt",
            "asm-lsp",
            "black",
            "flake8",
         },
      },
      config = function(_, confopts)
         require("mason").setup(confopts)
         local mr = require("mason-registry")
         local function ensure_installed()
            for _, tool in ipairs(confopts.ensure_installed) do
               local p = mr.get_package(tool)
               if not p:is_installed() then
                  p:install()
               end
               require('mason-lspconfig').setup({})
            end
         end
         if mr.refresh then
            mr.refresh(ensure_installed)
         else
            ensure_installed()
         end
         -- manually add some configuration
         local lspconfig = require("lspconfig");
         -- we need to advertise aditional capabilities for nvim-ufo
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true
         }
         capabilities = require('cmp_nvim_lsp').up

         local function on_attach(client)
            -- attach illuminate
            require('illuminate').on_attach(client)
            local sign = function(opts)
               vim.fn.sign_define(opts.name, {
                  texthl = opts.name,
                  text = opts.text,
                  --numhl =
               })
            end
            sign({ name = 'DiagnosticSignError', text = glyphs.diagnostics.BoldError })
            sign({ name = 'DiagnosticSignWarn', text = glyphs.diagnostics.BoldWarning })
            sign({ name = 'DiagnosticSignHint', text = glyphs.diagnostics.BoldHint })
            sign({ name = 'DiagnosticSignInfo', text = glyphs.diagnostics.BoldInformation })
            -- update while in insert mode
            -- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            --   virtual_text = false,
            --   signs = true,
            --   underline = true,
            --   update_in_insert = true,
            -- })
         end
         local lsp_flags = {
            debounce_text_changes = 150,
         }
         lspconfig.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
               workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true),
               },
               completion = {
                  workspaceWord = true,
                  callSnippet = "Both",
               },
               runtime = { version = "LuaJIT" },
               telemetry = { enable = false },
               diagnostics = {
                  enable = true,
                  groupSeverity = {
                     strong = "Warning",
                     strict = "Warning",
                  },
                  groupFileStatus = {
                     ["ambiguity"] = "Opened",
                     ["await"] = "Opened",
                     ["codestyle"] = "None",
                     ["duplicate"] = "Opened",
                     ["global"] = "Opened",
                     ["luadoc"] = "Opened",
                     ["redefined"] = "Opened",
                     ["strict"] = "Opened",
                     ["strong"] = "Opened",
                     ["type-check"] = "Opened",
                     ["unbalanced"] = "Opened",
                     ["unused"] = "Opened",
                  },
                  unusedLocalExclude = { "_*" },
                  globals = { "vim", "nvim" }
               },
               format = {
                  enable = true,
                  defaultConfig = {
                     indent_style = "space",
                     indent_size = "2",
                     continuation_indent = "2",
                     quote_style = "double",
                     continuation_indent_size = "2",
                  },
               },
            }
         }
         lspconfig.rust_analyzer.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
               ['rust_analyzer'] = {
                  cargo = { allFeatures = true },
                  checkOnSave = {
                     command = "clippy",
                     extraArgs = { "--no-deps" },
                  }
               },
            }
         }
         lspconfig.tsserver.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
               init_options = {
                  preferences = { -- i don't remember why but this is very important
                     importModuleSpecifierEnding = "js",
                     importModuleSpecifierPreference = "relative",
                  }
               }
            }
         })

         lspconfig.clangd.setup({
            -- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
            -- to add more `checks`, create  a `.clang-tidy` file in the root directory
            -- SEE: https://clang.llvm.org/extra/clang-tidy
            capabilities = capabilities,
            cmd = { "clangd", "--clang-tidy", "--header-insertion=iwyu", "--cross-file-rename" },
            settings = {
               ["compilationDatabaseCommand"] = "/home/liam/.config/clangd/config.yaml",
            },
            on_attach = function(client)
               -- Attach illuminate
               require('illuminate').on_attach(client)
               local sign = function(opts)
                  vim.fn.sign_define(opts.name, {
                     texthl = opts.name,
                     text = opts.text,
                  })
               end
               sign({ name = 'DiagnosticSignError', text = glyphs.diagnostics.BoldError })
               sign({ name = 'DiagnosticSignWarn', text = glyphs.diagnostics.BoldWarning })
               sign({ name = 'DiagnosticSignHint', text = glyphs.diagnostics.BoldHint })
               sign({ name = 'DiagnosticSignInfo', text = glyphs.diagnostics.BoldInformation })

               -- update while in insert mode
               -- vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
               --   virtual_text = false,
               --   signs = true,
               --   underline = true,
               --   update_in_insert = true,
               -- })
               -- Setup Clangd extensions
               require("clangd_extensions.inlay_hints").setup_autocmd()
               require("clangd_extensions.inlay_hints").set_inlay_hints()

               -- Add keymap for Clangd symbol info
               vim.keymap.set("n", "<leader>bi", "<cmd>ClangdSymbolInfo<CR>")
            end,
         })

         lspconfig.tailwindcss.setup({
            capabilities = capabilities,
            on_attach = on_attach,
         })

         lspconfig.jsonls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
         })

         lspconfig.eslint.setup({
            capabilities = capabilities,
            on_attach = on_attach
         })
         lspconfig.texlab.setup({
            capabilities = capabilities,
            on_attach = on_attach,
         })
         lspconfig.grammarly.setup({
            capabilities = capabilities,
            on_attach = on_attach,
         })

         lspconfig.gopls.setup {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
            init_options = {
               usePlaceholders = true,
               linkTarget = "pkg.go.dev",
               completionDocumentation = true,
               completeUnimported = true,
               deepCompletion = true,
               matcher = "CaseSensitive",
               symbolMatcher = "CaseSensitive",
            },
         }
         lspconfig.solargraph.setup {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
         }
         lspconfig.pyright.setup {
            on_attach = on_attach,
            flags = lsp_flags,
            capabilities = capabilities,
         }
         -- lspconfig.misspell.setup({
         --    capabilities = capabilities,
         --    on_attach = on_attach,
         -- })
      end
   }
}
