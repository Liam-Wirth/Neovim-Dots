local lspconfig = require("lspconfig")
local glyphs = require('util.glyphs')
local Keys = require('config.keymaps')
lspconfig.rust_analyzer.setup{
   settings = {
      ['rust_analyzer'] = {
	 cargo = {alFeatures = true},
	 checkOnSave = {
	    command = "clippy",
	    extraArgs = {"--no-deps"},
	 }
      },
   }
}
lspconfig.lua_ls.setup {
    ---    workspace = {
    ---      checkThirdParty = false,
    ---      library = vim.api.nvim_get_runtime_file("", true),
    ---    },
    ---    completion = {
    ---      workspaceWord = true,
    ---      callSnippet = "Both",
    ---    },
    ---    runtime = { version = "LuaJIT" },
    ---    telemetry = { enable = false },
    ---  diagnostics = {
    ---     enable = true,
    ---    groupSeverity = {
    ---      strong = "Warning",
    ---      strict = "Warning",
    ---    },
    ---    groupFileStatus = {
    ---      ["ambiguity"] = "Opened",
    ---      ["await"] = "Opened",
    ---      ["codestyle"] = "None",
    ---      ["duplicate"] = "Opened",
    ---      ["global"] = "Opened",
    ---      ["luadoc"] = "Opened",
    ---      ["redefined"] = "Opened",
    ---      ["strict"] = "Opened",
    ---      ["strong"] = "Opened",
    ---      ["type-check"] = "Opened",
    ---      ["unbalanced"] = "Opened",
    ---      ["unused"] = "Opened",
    ---    },
    ---    unusedLocalExclude = { "_*" },
    ---    globals = {"vim", "nvim"}
    ---  },
    ---  format = {
    ---    enable = true,
    ---    defaultConfig = {
    ---      indent_style = "space",
    ---      indent_size = "2",
    ---      continuation_indent_size = "2",
    ---    },
    ---  },
   }

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end
sign({name = 'DiagnosticSignError', text = glyphs.diagnostics.BoldError})
sign({name = 'DiagnosticSignWarn', text = glyphs.diagnostics.BoldWarning})
sign({name = 'DiagnosticSignHint', text = glyphs.diagnostics.BoldHint})
sign({name = 'DiagnosticSignInfo', text = glyphs.diagnostics.BoldInformation})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])
--Global Mappings
Keys.map('n','<leader>be',vim.diagnostic.open_float,{desc = "Open Float", remap = true, silent = true})
Keys.map('n', '<leader>b[', vim.diagnostic.goto_prev,{desc = "Go to next Diagnostic", remap = true, silent = true})
Keys.map('n', '<leader>b]', vim.diagnostic.goto_next,{desc = "go to previous diagnostic", remap = true, silent = true})
Keys.map('n', '<leader>bq', vim.diagnostic.setloclist, {desc = "Set Local List", remap = true, silent = true})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '<leader>bgD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>bgd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>bgi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>bwa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>bwr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>bwl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>bD', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ba', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>bgr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>.', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
