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
}

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
      vim.keymap.set("n", "<space>ba", function() vim.cmd.RustLsp("codeAction") end)
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

-- Setup formatter.nvim
require("formatter").setup({
   logging = false,
   filetype = {
      lua = {
         require("formatter.filetypes.lua").stylua,
      },
      python = {
         require("formatter.filetypes.python").black,
      },
      javascript = {
         require("formatter.filetypes.javascript").prettier,
      },
      typescript = {
         require("formatter.filetypes.typescript").prettier,
      },
      go = {
         require("formatter.filetypes.go").gofmt,
      },
      json = {
         require("formatter.filetypes.json").prettier,
      },
      yaml = {
         require("formatter.filetypes.yaml").prettier,
      },
      c = {
         require("formatter.filetypes.c").clangformat,
      },
      cpp = {
         require("formatter.filetypes.cpp").clangformat,
      },
      svelte = {
         require("formatter.filetypes.svelte").prettier,
      },
      -- Add other filetypes and their formatters here
   },
})

-- Create a command `:Format` to format the current buffer
vim.api.nvim_create_user_command("Format", function()
   local buf = vim.api.nvim_get_current_buf()
   local clients = vim.lsp.get_active_clients({ bufnr = buf })
   for _, client in ipairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
         if vim.lsp.buf.format then
            vim.lsp.buf.format({ bufnr = buf })
         elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
         end
         return
      end
   end
   -- If no LSP supports formatting, use formatter.nvim
   vim.cmd("Format")
end, { desc = "Format current buffer with LSP or formatter.nvim" })

-- Auto-format on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--    pattern = "*",
--    callback = function()
--       vim.cmd("Format")
--    end,
-- })

-- Setup mason-lspconfig
require("mason-lspconfig").setup {
   ensure_installed = servers,
}

-- Setup capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Configure LSP servers
for _, lsp in ipairs(servers) do
   require("lspconfig")[lsp].setup {
      on_attach = M.on_attach,
      capabilities = capabilities,
   }
end

-- Example custom configuration for basedpyright (assuming it's a valid LSP server)
require("lspconfig").basedpyright.setup {
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
}

-- Custom configuration for lua_ls
require("lspconfig").lua_ls.setup {
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
               quote_style = "double", continuation_indent_size = "2",
            },
         },
      },
   },
}

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
