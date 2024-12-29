local glyphs = require("util.glyphs")

local M = {}

-- Keymap to toggle LSP inlay hints

vim.keymap.set("n", "<leader>i", function()
   local buf = vim.api.nvim_get_current_buf()
   if vim.lsp.buf.inlay_hint then
      vim.lsp.buf.inlay_hint(buf, nil) -- Toggle inlay hints
   else
      require("notify")("Inlay Hints not supported by your current LSP, get that jawn fixed!")
   end
end, { desc = "Toggle Inlay Hints" })

-- Setup mason so it can manage external tooling
require("mason").setup()

-- List of LSP servers to ensure installed
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

}

-- TODO: Fix
require("conform").setup({
   formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      go = { "gofmt" },
      json = { "prettier" },
      yaml = { "prettier" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      svelte = { "prettier" },
   },
   vim.keymap.set({ "n", "v" }, "<leader>.", function()
      require("conform").format({
         lsp_fallback = true,
         async = false,
         timeout_ms = 500,
      })
   end, { desc = "Format file or range (in visual mode)" }),
})

vim.api.nvim_create_user_command("Format", function()
   require("conform").format({
      timeout_ms = 500,
      lsp_fallback = true,
   })
end, { desc = "Format current buffer with conform.nvim" })

M.on_attach = function(client, bufnr)
   -- Define a function to easily set key mappings for LSP-related items
   local nmap = function(keys, func, desc)
      if desc then
         desc = "LSP: " .. desc
      end
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
   end
   -- Attach illuminate if the client supports documentHighlight
   if client.server_capabilities.documentHighlightProvider then
      require("illuminate").on_attach(client)
   end

   -- Define diagnostic signs
   local sign = function(opts)
      vim.fn.sign_define(opts.name, {
         texthl = opts.name,
         text = opts.text,
      })
   end

   sign({ name = "DiagnosticSignError", text = glyphs.diagnostics.BoldError })
   sign({ name = "DiagnosticSignWarn", text = glyphs.diagnostics.BoldWarning })
   sign({ name = "DiagnosticSignHint", text = glyphs.diagnostics.BoldHint })
   sign({ name = "DiagnosticSignInfo", text = glyphs.diagnostics.BoldInformation })

   if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true)
   end

   local filetype = vim.bo.filetype
   if vim.tbl_contains({ "rust" }, filetype) then
      vim.keymap.set("n", "K", "<cmd>lua require'rustaceanvim'.hover_actions.hover_actions()<CR>")
      vim.keymap.set("n", "<space>ba", function()
         vim.cmd.RustLsp("codeAction")
      end)
   else
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("<leader>ba", vim.lsp.buf.code_action, "Code Action")
   end

   nmap("bgd", vim.lsp.buf.definition, "[G]oto [D]efinition")
   nmap("bgr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
   nmap("bgI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
   nmap("<leader>bD", vim.lsp.buf.type_definition, "Type [D]efinition")
   nmap("<leader>bd", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
   nmap("<leader>bws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

   nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

   -- Lesser used LSP functionality
   nmap("bgD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
   nmap("<leader>bwa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
   nmap("<leader>bwr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
   nmap("<leader>bwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, "[W]orkspace [L]ist Folders")
end

-- Setup mason-lspconfig
require("mason-lspconfig").setup({
   ensure_installed = servers,
})

-- Setup capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Configure LSP servers
for _, lsp in ipairs(servers) do
   require("lspconfig")[lsp].setup({
      on_attach = M.on_attach,
      capabilities = capabilities,
   })
end

-- Example custom configuration for basedpyright (assuming it's a valid LSP server)
require("lspconfig").basedpyright.setup({
   capabilities = capabilities,
   on_attach = M.on_attach,
   settings = {
      basedpyright = {
         analysis = {
            typeCheckingMode = "standard", -- off, basic, standard, strict, all
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
            diagnosticMode = "workspace",
         },
      },
   },
})

-- Custom configuration for lua_ls
require("lspconfig").lua_ls.setup({
   capabilities = capabilities,
   on_attach = M.on_attach,
   settings = {
      Lua = {
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
            globals = { "vim", "nvim" },
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
      },
   },
})

require("lspconfig").asm_lsp.setup({
   cmd = { "asm-lsp" },
   filetypes = { "asm", "s", "S", "nasm" },
   root_dir = require("lspconfig").util.root_pattern("Makefile"),
   settings = {
      nasm = {
         executable = "nasm",
         args = { "-f", "elf64", "-F", "dwarf", "-g" },
      },
   },
})

require("lspconfig").basedpyright.setup({
   capabilities = capabilities,
   on_attach = M.on_attach,
   settings = {
      python = {
         analysis = {
            typeCheckingMode = "off", -- Set to "off" to disable type checking warnings
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
            diagnosticSeverityOverrides = {
               -- Optionally override specific diagnostic severities
               reportMissingTypeStubs = "none",
               reportUnknownMemberType = "none",
               reportUnknownParameterType = "none",
               reportUnknownVariableType = "none",
               reportMissingTypeArgument = "none",
            },
         },
      },
   },
})

require("lspconfig").clangd.setup({
   on_attach = M.on_attach,
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
   root_dir = require("lspconfig").util.root_pattern("src"),
   init_options = { fallbackFlags = { "-std=c++2a" } },
})

-- Start bash-language-server for sh files
vim.api.nvim_create_autocmd("FileType", {
   pattern = "sh",
   callback = function()
      vim.lsp.start({
         name = "bash-language-server",
         cmd = { "bash-language-server", "start" },
      })
   end,
})

require("notify").setup({
   background_colour = "#000000",
})

return M
