local glyphs = require("util.glyphs")

return {
   {
      "neovim/nvim-lspconfig",
      event = { "BufReadPost", "BufNewFile" },
      dependencies = {
         "williamboman/mason.nvim",
         "williamboman/mason-lspconfig.nvim",
         "hrsh7th/cmp-nvim-lsp",
         "stevearc/conform.nvim",
         "rcarriga/nvim-notify",
      },
      config = function()
         -- Inlay hints toggle keybinding
         vim.keymap.set("n", "<leader>i", function()
            local buf = vim.api.nvim_get_current_buf()
            local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
            vim.notify(("Inlay hints %s"):format(enabled and "disabled" or "enabled"), vim.log.levels.INFO)
         end, { desc = "Toggle Inlay Hints" })

         -- --- Mason ---
         require("mason").setup()
         local servers = {
            "texlab",
            "verible",
            "clangd",
            "basedpyright",
            "jsonls",
            "eslint",
            "tailwindcss",
            "gopls",
            "svelte",
            "intelephense",
            "astro",
            "yamlls",
            "fortls",
            "marksman",
            "lua_ls",
            -- "asm_lsp",
            "ruff",
         }
         require("mason-lspconfig").setup({ ensure_installed = servers })

         -- --- conform.nvim (format) ---
         require("conform").setup({
            formatters_by_ft = {
               lua = { "stylua" },
               python = { "ruff" },
               javascript = { "prettier" },
               typescript = { "prettier" },
               go = { "gofmt" },
               json = { "prettier" },
               yaml = { "prettier" },
               c = { "clang_format" },
               cpp = { "clang_format" },
               svelte = { "prettier" },
            },
         })

         vim.keymap.set({ "n", "v" }, "<leader>.", function()
            require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
         end, { desc = "Format file or range (in visual mode)" })

         vim.api.nvim_create_user_command("Format", function()
            require("conform").format({ timeout_ms = 500, lsp_fallback = true })
         end, { desc = "Format current buffer with conform.nvim" })

         -- --- on_attach / UI ---
         local function on_attach(client, bufnr)
            local function nmap(keys, fn, desc)
               vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc and ("LSP: " .. desc) or nil })
            end

            -- Enable document highlight if supported
            if client.server_capabilities.documentHighlightProvider then
               pcall(function()
                  require("illuminate").on_attach(client)
               end)
            end

            local function sign(opts)
               vim.fn.sign_define(opts.name, { texthl = opts.name, text = opts.text })
            end
            sign({ name = "DiagnosticSignError", text = glyphs.diagnostics.BoldError })
            sign({ name = "DiagnosticSignWarn", text = glyphs.diagnostics.BoldWarning })
            sign({ name = "DiagnosticSignHint", text = glyphs.diagnostics.BoldHint })
            sign({ name = "DiagnosticSignInfo", text = glyphs.diagnostics.BoldInformation })

            -- Enable inlay hints if supported
            if client.server_capabilities.inlayHintProvider then
               vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end

            -- Rust-specific keybindings
            if vim.bo[bufnr].filetype == "rust" then
               vim.keymap.set("n", "K", function()
                  require("rustaceanvim").hover_actions.hover_actions()
               end, { buffer = bufnr, desc = "Hover Actions (Rust)" })
               vim.keymap.set("n", "<space>ba", function()
                  vim.cmd.RustLsp("codeAction")
               end, { buffer = bufnr, desc = "Code Action (Rust)" })
            else
               nmap("K", vim.lsp.buf.hover, "Hover")
               nmap("<leader>ba", vim.lsp.buf.code_action, "Code Action")
            end

            -- Common LSP keybindings
            nmap("bgd", vim.lsp.buf.definition, "[G]oto [D]efinition")
            nmap("bgr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("bgI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
            nmap("<leader>bD", vim.lsp.buf.type_definition, "Type [D]efinition")
            nmap("<leader>bd", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
            nmap("<leader>bws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
            nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
            nmap("bgD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
         end

         local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

         local manual = { basedpyright = true, lua_ls = true, clangd = true, asm_lsp = true, gopls = true, ruff = true, verible = true }

         for _, name in ipairs(servers) do
            if not manual[name] then
               vim.lsp.config(name, { on_attach = on_attach, capabilities = capabilities })
            end
         end

         -- Configure gopls with inlay hints
         vim.lsp.config("gopls", {
            on_attach = on_attach,
            capabilities = capabilities,
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
         })

         -- https://danielmangum.com/posts/setup-verible-verilog-neovim/
         vim.lsp.config("verible", {
              cmd = {'verible-verilog-ls', '--rules_config_search'},
         })

         -- Configure ruff for fast linting only (let basedpyright handle type checking)
         vim.lsp.config("ruff", {
            on_attach = function(client, bufnr)
               -- Disable hover in favor of basedpyright
               client.server_capabilities.hoverProvider = false
               on_attach(client, bufnr)
            end,
            capabilities = capabilities,
            init_options = {
               settings = {
                  -- Ruff language server settings
                  args = {},
               },
            },
         })

         vim.lsp.config("lua_ls", {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
               Lua = {
                  workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
                  completion = { workspaceWord = true, callSnippet = "Both" },
                  runtime = { version = "LuaJIT" },
                  telemetry = { enable = false },
                  hint = {
                     enable = true, -- Enable inlay hints for Lua
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
                        indent_size = "3", -- Match your config
                        continuation_indent = "3",
                        quote_style = "double",
                     },
                  },
               },
            },
         })

         vim.lsp.config("asm_lsp", {
            cmd = { "asm-lsp" },
            filetypes = { "asm", "s", "S", "nasm" },
            root_dir = function(bufnr, on_dir)
               local path = vim.api.nvim_buf_get_name(bufnr)
               local root = vim.fs.root(path, { "Makefile" }) or vim.fs.dirname(path)
               on_dir(root)
            end,
            settings = {
               nasm = { executable = "nasm", args = { "-f", "elf64", "-F", "dwarf", "-g" } },
            },
         })

         vim.lsp.config("basedpyright", {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
               basedpyright = {
                  analysis = {
                     diagnosticMode = "openFilesOnly", -- Only check open files for performance
                     typeCheckingMode = "standard", -- Use "standard" instead of "strict" for less noise
                     useLibraryCodeForTypes = true,
                     autoSearchPaths = true,
                     inlayHints = {
                        variableTypes = true,
                        callArgumentNames = "partial", -- Only show for complex calls
                        functionReturnTypes = true,
                        genericTypes = false,
                        parameterTypes = true,
                     },
                     diagnosticSeverityOverrides = {
                        reportMissingTypeStubs = "none", -- Ruff handles imports
                        reportUnknownVariableType = "information",
                        reportUnknownMemberType = "none",
                        reportUnknownParameterType = "none",
                        reportUnknownArgumentType = "none",
                     },
                  },
               },
            },
         })

         vim.lsp.config("clangd", {
            on_attach = on_attach,
            capabilities = capabilities,
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
            init_options = { fallbackFlags = { "-std=c++2a" } },
         })

         vim.api.nvim_create_autocmd("FileType", {
            pattern = "sh",
            callback = function()
               vim.lsp.start({ name = "bash-language-server", cmd = { "bash-language-server", "start" } })
            end,
         })

         -- Setup notify
         require("notify").setup({ background_colour = "#000000" })
         vim.notify = require("notify")

         -- Enable all configured LSP servers
         for _, server in ipairs(servers) do
            vim.lsp.enable(server)
         end
      end,
   },
}
