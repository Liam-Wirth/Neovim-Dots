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
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil,{focusable=false,scope="cursor"})]])
local misc_aucmds = vim.api.nvim_create_augroup('misc_aucmds', { clear = true })
vim.api.nvim_create_autocmd('BufReadPre', {
  group = misc_aucmds,
  callback = function()
    require('plugins.lsp.lspconf')
  end,
  
  once = true,
})
