vim.api.nvim_create_autocmd("colorscheme", {
  group = vim.api.nvim_create_augroup("coloringfuckery", { clear = true }),
  pattern = "*",
  callback = function()
    for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
    end
  end,
})

--!NOTE: [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})
--[[
local misc_aucmds = vim.api.nvim_create_augroup('misc_aucmds', { clear = true })
vim.api.nvim_create_autocmd('BufReadPre', {
  group = misc_aucmds,
  callback = function()
    require('plugins.lsp.lspconf')
  end,
  once = true,
})
--]]
local wk = require("which-key")
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
      --
wk.add({
  -- Group descriptions
  { "<leader>b", group = "LSP Buffer Actions" },
  { "<space>b", group = "LSP Buffer Workspace" },

  -- Individual keymaps with descriptions
  { "<leader>bgD", vim.lsp.buf.declaration, desc = "Go to Declaration", mode = "n" },
  { "<leader>bgd", vim.lsp.buf.definition, desc = "Go to Definition", mode = "n" },
  { "K", vim.lsp.buf.hover, desc = "Hover Documentation", mode = "n" },
  { "<leader>bgi", vim.lsp.buf.implementation, desc = "Go to Implementation", mode = "n" },
  { "<C-k>", vim.lsp.buf.signature_help, desc = "Signature Help", mode = "n" },
  
  -- Workspace management
  { "<space>bwa", vim.lsp.buf.add_workspace_folder, desc = "Add Workspace Folder", mode = "n" },
  { "<space>bwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder", mode = "n" },
  { "<space>bwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, desc = "List Workspace Folders", mode = "n" },

  { "<space>bD", vim.lsp.buf.type_definition, desc = "Type Definition", mode = "n" },
  { "<space>br", vim.lsp.buf.rename, desc = "Rename Symbol", mode = "n" },
  { "<space>ba", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
  { "<leader>bgr", vim.lsp.buf.references, desc = "List References", mode = "n" },
  { "<space>.", function()
      vim.lsp.buf.format { async = true }
    end, desc = "Format Code", mode = "n" },
})
   end })

    --local opts = { buffer = ev.buf }
    --vim.keymap.set('n', '<leader>bgD', vim.lsp.buf.declaration, opts)
    --vim.keymap.set('n', '<leader>bgd', vim.lsp.buf.definition, opts)
    --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    --vim.keymap.set('n', '<leader>bgi', vim.lsp.buf.implementation, opts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', '<space>bwa', vim.lsp.buf.add_workspace_folder, opts)
    --vim.keymap.set('n', '<space>bwr', vim.lsp.buf.remove_workspace_folder, opts)
    --vim.keymap.set('n', '<space>bwl', function()
      --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, opts)
    --vim.keymap.set('n', '<space>bD', vim.lsp.buf.type_definition, opts)
    --vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    --vim.keymap.set({ 'n', 'v' }, '<space>ba', vim.lsp.buf.code_action, opts)
    --vim.keymap.set('n', '<leader>bgr', vim.lsp.buf.references, opts)
    --vim.keymap.set('n', '<space>.', function()
      --vim.lsp.buf.format { async = true }
    --end, opts)
  --end,

