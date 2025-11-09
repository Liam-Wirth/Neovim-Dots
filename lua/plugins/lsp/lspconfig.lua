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
         vim.keymap.set("n", "<leader>i", function()
            local buf = vim.api.nvim_get_current_buf()
            local ok_is, is_enabled = pcall(vim.lsp.inlay_hint.is_enabled, buf)
            local enabled = ok_is and is_enabled or false
            pcall(vim.lsp.inlay_hint.enable, buf, not enabled)
            if not ok_is then
               require("notify")("Inlay hints unsupported by current LSP", "warn")
            end
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
            "asm_lsp",
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

            if client.server_capabilities.inlayHintProvider then
               pcall(vim.lsp.inlay_hint.enable, bufnr, true)
            end

            if vim.bo[bufnr].filetype == "rust" then
               vim.keymap.set("n", "K", function()
                  require("rustaceanvim").hover_actions.hover_actions()
               end, { buffer = bufnr })
               vim.keymap.set("n", "<space>ba", function()
                  vim.cmd.RustLsp("codeAction")
               end, { buffer = bufnr })
            else
               nmap("K", vim.lsp.buf.hover, "Hover")
               nmap("<leader>ba", vim.lsp.buf.code_action, "Code Action")
            end

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

         local manual = { basedpyright = true, lua_ls = true, clangd = true, asm_lsp = true }
         for _, name in ipairs(servers) do
            if not manual[name] then
               vim.lsp.config(name, { on_attach = on_attach, capabilities = capabilities })
            end
         end

         vim.lsp.config("lua_ls", {
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
               Lua = {
                  workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
                  completion = { workspaceWord = true, callSnippet = "Both" },
                  runtime = { version = "LuaJIT" },
                  telemetry = { enable = false },
                  diagnostics = {
                     enable = true,
                     globals = { "vim", "nvim" },
                     unusedLocalExclude = { "_*" },
                  },
                  format = {
                     enable = true,
                     defaultConfig = {
                        indent_style = "space",
                        indent_size = "2",
                        continuation_indent = "2",
                        quote_style = "double",
                     },
                  },
               },
            },
         })

         vim.lsp.config("asm_lsp", {
            cmd = { "asm-lsp" },
            filetypes = { "asm", "s", "S", "nasm" },
            root_dir = function(startpath)
               return vim.fs.root(startpath, { "Makefile" })
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
                     diagnosticMode = "workspace",
                     typeCheckingMode = "strict",
                     useLibraryCodeForTypes = true,
                     inlayHints = {
                        variableTypes = true,
                        callArgumentNames = true,
                        functionReturnTypes = true,
                        genericTypes = false,
                     },
                     diagnosticSeverityOverrides = {
                        reportMissingTypeStubs = "warning",
                        reportUnknownVariableType = "warning",
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
               "--pch-storage=memory",
               "--all-scopes-completion",
               "--pretty",
               "--header-insertion=never",
               "-j=4",
               "--inlay-hints",
               "--header-insertion-decorators",
               "--function-arg-placeholders",
               "--completion-style=detailed",
            },
            filetypes = { "c", "cpp", "objc", "objcpp" },
            root_dir = function(startpath)
               return vim.fs.root(startpath, { "compile_commands.json", "compile_flags.txt", "src" })
            end,
            init_options = { fallbackFlags = { "-std=c++2a" } },
         })

         vim.api.nvim_create_autocmd("FileType", {
            pattern = "sh",
            callback = function()
               vim.lsp.start({ name = "bash-language-server", cmd = { "bash-language-server", "start" } })
            end,
         })

         -- notify appearance
         require("notify").setup({ background_colour = "#000000" })
         vim.notify = require("notify")
         vim.lsp.enable(servers)
      end,
   },
}
