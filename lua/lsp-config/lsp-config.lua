local vim = vim
local wk = require("which-key")
--  This function gets run when an LSP connects to a particular buffer.
local nvim_lsp = require("lspconfig")
local on_attach = function(_, bufnr)

  require("illuminate").on_attach(_)
  vim.keymap.set("n", "<M-n>", function()
    require("illuminate").next_reference({ wrap = true })
  end)
  vim.keymap.set("n", "<M-p>", function()
    require("illuminate").next_reference({ reverse = true, wrap = true })
  end)

  vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
  vim.cmd([[echo "The lsp was attatched and my keybinds should work"]])
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  --TODO: list all of these keybinds under which-key

  -- Use rust-tools.nvim's hover if we're editing rust, else fallback to the default hover handler
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "rust" }, filetype) and packer_plugins["rust-tools.nvim"] then
    vim.keymap.set("n", "K", "<cmd>lua require'rust-tools'.hover_actions.hover_actions()<CR>")
  else
    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
  end

  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end
  nmap("<leader>Ln", vim.lsp.buf.rename, "[R]e[n]ame")
  wk.register({
    L = {
      name = "LSP",
      r = { "<cmd> vim.lsp.buf.rename() <cr>", "Rename" },
      c = { "[C]ode [A]ction" },
    },
    g = {
      name = "LSP: Goto",
      d = { "<cmd> vim.lsp.buf.definition <cr>", "[G]oto [D]efinition" },
      i = { "<cmd> vim.lsp.buf.implementation<cr>", "[G]oto [I]mplementation" },
      r = { [[<cmd> require("telescope.builtin").lsp_references <cr>]], "[G]oto [R]eferences" },
      D = { "<cmd>vim.lsp.buf.declaration, <cr>", "[G]oto [D]eclaration" },
    },
  }, { prefix = "<leader>", buffer = bufnr })
  nmap("<leader>Lca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("<leader>gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("<leader>gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>k", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = "Format current buffer with LSP" })
-- Set autocommands conditional on server_capabilities
    if _.server_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
        augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        hi LspReferenceRead  cterm=bold ctermbg=red guibg=#4b1b89
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=#4b1b89
        hi LspReferenceText  cterm=bold ctermbg=red guibg=#4b1b89
        augroup END
    ]],
            false
        )
    end

end

-- nvim-cmp supports additional completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Setup mason so it can manage external tooling
require("mason").setup()

  -- Enable the following language servers
local servers = { "clangd", "rust_analyzer", "pyright", "tsserver", "lua_ls" }

-- Ensure the servers above are installed
require("mason-lspconfig").setup({
  ensure_installed = servers,
})

for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end
for _, lsp in ipairs(servers) do
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        update_in_insert = true,
    }
    nvim_lsp[lsp].setup(opts)
end



--below is how I would setup manual configurations of different lsp servers
--require("lspconfig").sumneko_lua.setup({
--    on_attach = on_attach,
--    settings = {
--        Lua = {
--            diagnostics = {
--                globals = { "vim" },
--            },
--        },
--    },
--})
require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})
