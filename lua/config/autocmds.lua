local vim=vim -- HACK: lol
vim.api.nvim_create_autocmd("colorscheme", {
   group = vim.api.nvim_create_augroup("coloringfuckery", { clear = true }),
   pattern = "*",
   callback = function()
      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
         vim.api.nvim_set_hl(0, group, {})

      end
   end,
})


local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank()
   end,
   group = highlight_group,
   pattern = "*",
})
-- HACK: wtf is this doing in the autocmds file???
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
         { "<leader>b",   group = "LSP Buffer Actions" },
         { "<space>b",    group = "LSP Buffer Workspace" },

         -- Individual keymaps with descriptions
         { "<leader>bgD", vim.lsp.buf.declaration,             desc = "Go to Declaration",       mode = "n" },
         { "<leader>bgd", vim.lsp.buf.definition,              desc = "Go to Definition",        mode = "n" },
         { "K",           vim.lsp.buf.hover,                   desc = "Hover Documentation",     mode = "n" },
         { "<leader>bgi", vim.lsp.buf.implementation,          desc = "Go to Implementation",    mode = "n" },
         { "<C-k>",       vim.lsp.buf.signature_help,          desc = "Signature Help",          mode = "n" },

         -- Workspace management
         { "<space>bwa",  vim.lsp.buf.add_workspace_folder,    desc = "Add Workspace Folder",    mode = "n" },
         { "<space>bwr",  vim.lsp.buf.remove_workspace_folder, desc = "Remove Workspace Folder", mode = "n" },
         {
            "<space>bwl",
            function()
               print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "List Workspace Folders",
            mode = "n"
         },

         { "<space>bD", vim.lsp.buf.type_definition, desc = "Type Definition", mode = "n" },
         { "<space>br", desc = "Rename Symbol",      mode = "n" },
         { "<space>ba", desc = "Code Action",        mode = { "n", "v" } },
         {
            "<space>.",
            function()
               vim.lsp.buf.format { async = true }
            end,
            desc = "Format Code",
            mode = "n"
         },
      })
   end
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
   callback = function()
      if vim.w.auto_cursorline then
         vim.wo.cursorline = true
         vim.w.auto_cursorline = nil
      end
   end,
})
local color_fix_group = vim.api.nvim_create_augroup("ColorFixes", { clear = true })

-- Fix for the gray text in new, untyped buffers
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
   group = color_fix_group,
   pattern = "*",
   callback = function()
      if vim.bo.filetype == "" then
         -- Set 'Normal' highlight explicitly. Adapt colors to your preference.
         vim.cmd("highlight Normal guifg=#ebdbb2 guibg=#282828") -- Gruvbox colors
         -- Alternative, using doom-one colors if that's the current scheme:
         -- if vim.g.colorscheme == "doom-one" then
         --   vim.cmd("highlight Normal guifg=#bbc2cf guibg=#282c34")
         -- end
      end
   end,
})
