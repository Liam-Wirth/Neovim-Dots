local glyphs = require("util.glyphs")

return {
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
         { "mason-org/mason.nvim", version = "^2.0.0" },
         { "mason-org/mason-lspconfig.nvim", version = "^2.0.0" },
         "rcarriga/nvim-notify",
      },
      opts_extend = { "servers.*.keys" },
      opts = function()
         ---@class LspOpts
         local opts = {
            -- Diagnostic configuration
            diagnostics = {
               underline = true,
               update_in_insert = false,
               virtual_text = {
                  spacing = 4,
                  source = "if_many",
                  prefix = "●",
               },
               severity_sort = true,
               signs = {
                  text = {
                     [vim.diagnostic.severity.ERROR] = glyphs.diagnostics.BoldError,
                     [vim.diagnostic.severity.WARN] = glyphs.diagnostics.BoldWarning,
                     [vim.diagnostic.severity.HINT] = glyphs.diagnostics.BoldHint,
                     [vim.diagnostic.severity.INFO] = glyphs.diagnostics.BoldInformation,
                  },
               },
               float = {
                  border = "rounded",
                  source = "if_many",
                  header = "",
                  prefix = "",
               },
            },

            -- Inlay hints configuration
            inlay_hints = {
               enabled = true,
               exclude = { "vue" },
            },

            -- Code folding configuration
            folds = {
               enabled = true,
            },

            -- Code lens configuration
            codelens = {
               enabled = true,
            },

            format = {
               timeout_ms = 500,
               async = false,
            },
            ---@type table<string, vim.lsp.Config|boolean>
            servers = {
               -- Global server configuration
               ["*"] = {
                  capabilities = {
                     workspace = {
                        fileOperations = {
                           didRename = true,
                           willRename = true,
                        },
                     },
                  },
                  keys = {
                     -- NOTE: hover (K) and code actions (<leader>ba) are owned by
                     -- lspsaga (plugins/lsp/lspsaga.lua); rust overrides per-buffer.
                     { "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
                     {
                        "gr",
                        function()
                           require("telescope.builtin").lsp_references()
                        end,
                        desc = "References",
                     },
                     { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
                     { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
                     { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
                     { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
                     { "<leader>bD", vim.lsp.buf.type_definition, desc = "Type Definition" },
                     {
                        "<leader>bd",
                        function()
                           require("telescope.builtin").lsp_document_symbols()
                        end,
                        desc = "Document Symbols",
                     },
                     {
                        "<leader>bws",
                        function()
                           require("telescope.builtin").lsp_dynamic_workspace_symbols()
                        end,
                        desc = "Workspace Symbols",
                     },
                  },
               },

               -- Lua configuration. Runtime/plugin type info is provided
               -- on-demand by lazydev.nvim (see spec below) instead of
               -- indexing the entire runtimepath here.
               lua_ls = {
                  settings = {
                     Lua = {
                        workspace = {
                           checkThirdParty = false,
                        },
                        completion = { workspaceWord = true, callSnippet = "Both" },
                        runtime = { version = "LuaJIT" },
                        telemetry = { enable = false },
                        hint = {
                           enable = true,
                           setType = true,
                           paramName = "All",
                           paramType = true,
                           await = true,
                        },
                        diagnostics = {
                           enable = true,
                           globals = { "vim", "nvim" },
                           unusedLocalExclude = { "_*" },
                        },
                        format = {
                           enable = true,
                           defaultConfig = {
                              indent_style = "space",
                              indent_size = "3",
                              continuation_indent = "3",
                              quote_style = "double",
                           },
                        },
                     },
                  },
               },

               -- Go configuration
               gopls = {
                  settings = {
                     gopls = {
                        hints = {
                           assignVariableTypes = true,
                           compositeLiteralFields = true,
                           compositeLiteralTypes = true,
                           constantValues = true,
                           functionTypeParameters = true,
                           parameterNames = true,
                           rangeVariableTypes = true,
                        },
                        analyses = {
                           unusedparams = true,
                           shadow = true,
                        },
                        staticcheck = true,
                     },
                  },
               },

               -- Python configuration
               basedpyright = {
                  cmd = { "basedpyright-langserver", "--stdio" },
                  settings = {
                     basedpyright = {
                        analysis = {
                           diagnosticMode = "openFilesOnly",
                           typeCheckingMode = "standard",
                           useLibraryCodeForTypes = true,
                           autoSearchPaths = true,
                           inlayHints = {
                              variableTypes = true,
                              callArgumentNames = "partial",
                              functionReturnTypes = true,
                              genericTypes = false,
                              parameterTypes = true,
                           },
                           diagnosticSeverityOverrides = {
                              reportMissingTypeStubs = "none",
                              reportUnknownVariableType = "information",
                              reportUnknownMemberType = "none",
                              reportUnknownParameterType = "none",
                              reportUnknownArgumentType = "none",
                           },
                        },
                     },
                  },
               },

               -- Ruff (Python linter)
               ruff = {
                  init_options = {
                     settings = {
                        args = {},
                     },
                  },
                  on_attach = function(client, _)
                     -- Disable hover in favor of basedpyright
                     client.server_capabilities.hoverProvider = false
                  end,
               },

               -- C/C++ configuration
               clangd = {
                  cmd = {
                     "clangd",
                     "--background-index",
                     "--clang-tidy",
                     "--completion-style=detailed",
                     "--header-insertion=never",
                     "--function-arg-placeholders",
                     "--fallback-style=llvm",
                     "--inlay-hints",
                     "-j=4",
                  },
                  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
                  root_dir = function(bufnr, on_dir)
                     local path = vim.api.nvim_buf_get_name(bufnr)
                     local root = vim.fs.root(path, {
                        "compile_commands.json",
                        "compile_flags.txt",
                        ".clangd",
                        ".clang-format",
                        ".git",
                     }) or vim.fs.dirname(path)
                     on_dir(root)
                  end,
               },

               -- Verilog configuration
               verible = {
                  cmd = { "verible-verilog-ls", "--rules_config_search" },
               },

               -- No special config needed -- just registered so vim.lsp.config
               -- knows about them if installed manually via :Mason.
               texlab = {},
               jsonls = {},
               eslint = {},
               tailwindcss = {},
               svelte = {},
               intelephense = {},
               astro = {},
               yamlls = {},
               fortls = {},
               marksman = {},
            },

            -- Setup function for custom server configurations
            ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
            setup = {
               -- Custom setups can go here if needed
            },
         }

         return opts
      end,

      config = function(_, opts)
         vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

         require("mason").setup()
         require("mason-lspconfig").setup({
            -- Declarative server install list (documented best practice).
            -- Mason installs anything missing in the background at startup;
            -- automatic_enable (default) calls vim.lsp.enable() for each.
            -- rust-analyzer is managed by rustaceanvim, jdtls by nvim-jdtls.
            ensure_installed = {
               "lua_ls",
               "basedpyright",
               "ruff",
               "clangd",
               "eslint",
               "fortls",
               "marksman",
               "texlab",
               "verible",
            },
            automatic_enable = {
               exclude = { "jdtls" },
            },
         })

         -- Toggle inlay hints keybinding
         vim.keymap.set("n", "<leader>i", function()
            local buf = vim.api.nvim_get_current_buf()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
            vim.notify(("Inlay hints %s"):format(enabled and "disabled" or "enabled"), vim.log.levels.INFO)
         end, { desc = "Toggle Inlay Hints" })

         -- Setup on_attach callback
         local function on_attach(client, bufnr)
            -- Enable document highlight
            if client.server_capabilities.documentHighlightProvider then
               pcall(function()
                  require("illuminate").on_attach(client)
               end)
            end

            -- Enable inlay hints if supported
            if opts.inlay_hints.enabled and client.server_capabilities.inlayHintProvider then
               vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            -- Set up keymaps from opts
            local keymaps = vim.deepcopy(opts.servers["*"].keys or {})
            local server_keymaps = opts.servers[client.name] and opts.servers[client.name].keys or {}
            for _, keymap in ipairs(server_keymaps) do
               table.insert(keymaps, keymap)
            end

            for _, keymap in ipairs(keymaps) do
               local keys, fn, desc = keymap[1], keymap[2], keymap.desc
               local mode = keymap.mode or "n"
               vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = desc })
            end

            -- Rust-specific handling
            if vim.bo[bufnr].filetype == "rust" then
               vim.keymap.set("n", "K", function()
                  require("rustaceanvim").hover_actions.hover_actions()
               end, { buffer = bufnr, desc = "Hover Actions (Rust)" })
               vim.keymap.set("n", "<leader>ba", function()
                  vim.cmd.RustLsp("codeAction")
               end, { buffer = bufnr, desc = "Code Action (Rust)" })
            end
         end

         -- Get capabilities: 0.11 registers most completion capabilities natively;
         -- merge blink.cmp's extras when it's available.
         local capabilities = vim.lsp.protocol.make_client_capabilities()
         local ok_blink, blink = pcall(require, "blink.cmp")
         if ok_blink then
            capabilities = blink.get_lsp_capabilities(capabilities)
         end

         -- Register (but do not enable) every configured server. `vim.lsp.config`
         -- just stores the config for later use by `vim.lsp.enable()` -- it does not
         -- start anything on its own, so this is safe to run unconditionally.
         for server_name, server_config in pairs(opts.servers) do
            if server_name ~= "*" then
               server_config = server_config == true and {}
                  or (not server_config) and { enabled = false }
                  or server_config
               if server_config.enabled ~= false then
                  server_config.on_attach = server_config.on_attach or on_attach
                  server_config.capabilities = capabilities
                  vim.lsp.config(server_name, server_config)
               end
            end
         end

         -- Apply global server config
         if opts.servers["*"] then
            vim.lsp.config("*", {
               capabilities = capabilities,
               on_attach = on_attach,
            })
         end

         -- Enable LSP-based code folding
         if opts.folds.enabled then
            vim.api.nvim_create_autocmd("LspAttach", {
               callback = function(args)
                  local client = vim.lsp.get_client_by_id(args.data.client_id)
                  if client and client.server_capabilities.foldingRangeProvider then
                     vim.wo.foldmethod = "expr"
                     vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
                     vim.wo.foldenable = false
                  end
               end,
            })
         end

         -- Enable code lens if configured
         -- TODO: Fix this/migrate off of deprecated stuff
         if opts.codelens.enabled then
            vim.api.nvim_create_autocmd("LspAttach", {
               callback = function(args)
                  local client = vim.lsp.get_client_by_id(args.data.client_id)
                  if client and client:supports_method("textDocument/codeLens") then
                     vim.lsp.codelens.refresh()
                     vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = args.buf,
                        callback = vim.lsp.codelens.refresh,
                     })
                  end
               end,
            })
         end

         -- Setup notify
         require("notify").setup({ background_colour = "#000000" })
         vim.notify = require("notify")
      end,
   },

   -- Lua development: feeds lua_ls type info for the Neovim runtime and
   -- plugins you actually require(), on demand -- instead of indexing the
   -- whole runtimepath (which made Lua completion slow and noisy).
   {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
         library = {
            -- Load luvit types when vim.uv is referenced
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
         },
      },
   },
}
