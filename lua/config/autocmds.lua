local vim = vim -- HACK: lol
vim.api.nvim_create_autocmd("colorscheme", {
   group = vim.api.nvim_create_augroup("coloringfuckery", { clear = true }),
   pattern = "*",
   callback = function()
      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
         vim.api.nvim_set_hl(0, group, {})
      end
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
         fg = "#928374",
         italic = true,
         bg = "NONE",
      })
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

-- LSP keybindings are now defined in lspconfig.lua on_attach function

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
   callback = function()
      if vim.w.auto_cursorline then
         vim.wo.cursorline = true
         vim.w.auto_cursorline = nil
      end
   end,
})
local color_fix_group = vim.api.nvim_create_augroup("ColorFixes", { clear = true })

