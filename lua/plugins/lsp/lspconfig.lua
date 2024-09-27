wk = require("which-key")
-- NOTE: The error regarding lspconfig being weird and mason servers not loading right might be here
local glyphs = require('util.glyphs')

local on_attach = function(client, bufnr)
   -- Define a function to easily set key mappings for LSP-related items
   local nmap = function(keys, func, desc)
      if desc then
         desc = 'LSP: ' .. desc
      end
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
   end

   -- Attach illuminate if the client supports documentHighlight
   if client.server_capabilities.documentHighlightProvider then
      require('illuminate').on_attach(client)
   end

   -- Define diagnostic signs
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

   -- Define key mappings
   nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
   nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
   nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
   nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')


   nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
   nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
   nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
   nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
   nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
   nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
   nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
   nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

   -- See `:help K` for why this keymap
   nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
   nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

   -- Lesser used LSP functionality
   nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
   nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
   nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
   nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, '[W]orkspace [L]ist Folders')

   -- Create a command `:Format` local to the LSP buffer
   if client.server_capabilities.documentFormattingProvider or client.server_capabilities.documentRangeFormattingProvider then
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
         if vim.lsp.buf.format then
            vim.lsp.buf.format()
         elseif vim.lsp.buf.formatting then
            vim.lsp.buf.formatting()
         end
      end, { desc = 'Format current buffer with LSP' })
   else
      vim.cmd[[
      echo POOP
      ]]
      vim.api.nvim_create_autocmd("BufWritePre", {
         pattern = "*",
         callback = function(args)
            require("conform").format({ bufnr = args.buf })
         end,
      })
   end
end
-- Setup mason so it can manage external tooling
require('mason').setup()
local servers = {
   -- "stylua",
   -- "shfmt",
   -- "lua-language-server",
   "texlab",
   -- "bibtex-tidy",
   -- "misspell",
   -- "svls",
   "verible",
   -- "cpptools",
   -- "clang-format",
   "clangd",
   -- "prettier",
   -- "cpplint",
   "basedpyright",
   -- "asmfmt",
   -- "asm-lsp",
   -- "black",
   -- "flake8",
   -- "bash-language-server",
   "biome",
   -- "astro-language-server",
   -- "omnisharp-mono",
   -- "solargraph",
   -- "tsserver",
   "jsonls",
   "eslint",
   "tailwindcss",
   "gopls",
   "svelte",
   "intelephense",
   "astro",
   "yamlls",
   "fortls",
   "marksman"
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason-lspconfig').setup {
   ensure_installed = servers,
   handlers = { function(server) require("astrolsp").lsp_setup(server) end },
}
for _, lsp in ipairs(servers) do
   require('lspconfig')[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
   }
end

-- Turn on lsp status information

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').basedpyright.setup {
   capabilities = capabilities,
   on_attach = on_attach,
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
require('lspconfig').lua_ls.setup {
   capabilities = capabilities,
   on_attach = on_attach,
   settings = {
      globals = { "vim", "nvim" },
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

vim.api.nvim_create_autocmd('FileType', {
   pattern = 'sh',
   callback = function()
      vim.lsp.start({
         name = 'bash-language-server',
         cmd = { 'bash-language-server', 'start' },
      })
   end,
})

--lol
require("notify").setup({
   background_colour = "#000000",
})
