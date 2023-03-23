-- Add additional capabilities supported by nvim-cmp
local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require 'luasnip'
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
--CMP setup
local cmp = require 'cmp'
cmp.setup {

  enabled = function()
    -- disable completion in comments
    local context = require 'cmp.config.context'
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == 'c' then
      return true
    else
      return not context.in_treesitter_capture("comment")
          and not context.in_syntax_group("Comment")
    end
  end,
  completion = {
    completeopt = "menu,menuone,noinsert",
  },

  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  experimental = {
    ghost_text = true,
  },
  view = {
    native_menu = true,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  -----------------------------------------------------------------------------------------------------------------------------------------
  --                                                               Mappings                                                              --
  -----------------------------------------------------------------------------------------------------------------------------------------

  --  mapping = cmp.mapping.preset.insert({
  --     ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --     ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --     ['<C-Space>'] = cmp.mapping.complete(),
  --     ['<C-e>'] = cmp.mapping.abort(),
  --     ['<CR>'] = cmp.mapping.confirm({ select = false}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  --   ["<Tab>"] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_next_item()
  --     elseif luasnip.expand_or_jumpable() then
  --       luasnip.expand_or_jump()
  --     elseif has_words_before() then
  --       cmp.complete()
  --     else
  --       fallback()
  --     end
  --   end, { "i", "s" }),

  --   ["<S-Tab>"] = cmp.mapping(function(fallback)
  --     if cmp.visible() then
  --       cmp.select_prev_item()
  --     elseif luasnip.jumpable(-1) then
  --       luasnip.jump(-1)
  --     else
  --       fallback()
  --     end
  --   end, { "i", "s" }),
  -- }),
  --TODO: add these bindings to Whichkey
  mapping = {
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs( -4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<S-CR>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      { "i", "c" }
    ),
  },
  -----------------------------------------------------------------------------------------------------------------------------------------
  --                                                               Sources                                                               --
  -----------------------------------------------------------------------------------------------------------------------------------------
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'jdtls' },
    { name = 'orgmode' },
    { name = "omni" },
    {
      name = "buffer",
      option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = "nvim_lua" },
    { name = "crates" },
    { name = 'orgmode' },
    { name = "path" },
    { name = "calc" },
    { name = "vim-dadbod-completion" },
  },
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      vim_item.menu = ({
            buffer = "",
            nvim_lsp = "",
            spell = "",
            look = "",
            unit = "",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
          })[entry.source.name]
      return vim_item
    end,
  },
}
cmp.setup.cmdline(":", {
  mapping = {
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
    ["<TAB>"] = cmp.mapping({
      c = cmp.mapping.confirm({ select = true }),
    }, { "i", "c" }),
    ["<S-CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
    }, { "i", "c" }),
  },
  sources = {
    { name = "cmdline", keyword_length = 1 },
    { name = "path" },
  },
})
-- Use buffer source for `/`.
cmp.setup.cmdline("/", {
  mapping = {
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
    ["<TAB>"] = cmp.mapping({
      c = cmp.mapping.confirm({ select = true }),
    }, { "i", "c" }),
    ["<S-CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
    }, { "i", "c" }),
  },
  sources = {
    { name = "buffer" },
  },
})
cmp.setup.cmdline("?", {
  mapping = {
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
    ["<TAB>"] = cmp.mapping({
      c = cmp.mapping.confirm({ select = false }),
    }),
    ["<S-CR>"] = cmp.mapping({
      i = cmp.mapping.confirm({ select = true }),
    }),
  },
  sources = {
    { name = "buffer" },
  },
})
