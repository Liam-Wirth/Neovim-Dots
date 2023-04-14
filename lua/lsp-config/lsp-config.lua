local vim = vim
local wk = require('which-key')
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    --TODO list all of these keybinds under which-key
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
            --         r = {"<cmd> vim.lsp.buf.rename() <cr>", "Rename"},
            --         c = {"[C]ode [A]ction"},
        },
        g = { name = "LSP: Goto" }
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
