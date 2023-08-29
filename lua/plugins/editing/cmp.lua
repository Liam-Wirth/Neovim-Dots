local vim = vim
return {
      {
    "hrsh7th/nvim-cmp",
    version = false,       -- last release is way too old
    event = "BufReadPre",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/cmp-calc" },
      { "rafamadriz/friendly-snippets" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-omni" },
      {"onsails/lspkind-nvim", module = "lspkind"}
    },
    opts = function ()
      -- Add additional capabilities supported by nvim-cmp

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local luasnip = require("luasnip")
local lspkind = require("lspkind")
lspkind.init({
  symbol_map = {
    TypeParameter = "",
  },
})
--CMP setup
local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None, --Don't automatically select a completion
  -- disable completion in comments
  enabled = function()
    local context = require("cmp.config.context")
    -- keep command mode completion enabled when cursor is in a comment
    if vim.api.nvim_get_mode().mode == "c" then
      return true
    else
      return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
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
  sources = cmp.config.sources({
    { name = "luasnip", priority = 10 }, -- Force snippet/lsp suggestions to the top
    { name = "nvim_lsp", priority = 9 },
    { name = "nvim-lua" },
    { name = "crates" },
    { name = "vim-dadbod-completion" },
    { name = "neorg" },
    { name = "calc" },
    { name = "path" },
    {
      name = "buffer",
      priority = -2, -- Force buffer suggestions to the bottom
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    },
  }),
  experimental = {
    ghost_text = true,
  },
  window = {
    completion = cmp.config.window.bordered({
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
      col_offset = -3,
      side_padding = 0,
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "",
    }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      local kind = lspkind.cmp_format({
        mode = "symbol_text",
        maxwidth = 50,
        menu = { omni = "omni" },
      })(entry, vim_item)
      local strings = vim.split(kind.kind, "%s", { trimempty = true })

      kind.kind = " " .. (strings[1] or "") .. " "

      -- Kind icons
      --vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      -- Source
      local menu_icon = {
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        calc = " 󰃬 ",
      }
      if entry.source.name == "calc" then
        -- Get the custom icon for 'calc' source
        -- Replace the kind glyph with the custom icon
        vim_item.kind = menu_icon.calc
        vim_item.menu = "Calculator"
        kind.menu = "Calculator"
      end
      kind.menu = "    (" .. (strings[2] or "") .. ") "
      return kind
    end,
  },

  view = {
    native_menu = false,
    entries = "custom",
    window = {
      completion = {
        border = "rounded",
        winhighlight = "FloatBorder",
      },
    },
  }, -----------------------------------------------------------------------------------------------------------------------------------------
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
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
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
    ["<Tab>"] = cmp.mapping(
      cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      { "i", "c" }
    ),
  },
})
-----------------------------------------------------------------------------------------------------------------------------------------
--                                                               Sources                                                               --
-----------------------------------------------------------------------------------------------------------------------------------------

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
local doomcolors = require("util.doomcolors").dark

-- Customization for Pmenu
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = doomcolors.red })
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = doomcolors.red })
vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = doomcolors.red })

vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#EED8DA", bg = doomcolors.green })
vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#EED8DA", bg = doomcolors.green })
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#EED8DA", bg = doomcolors.green })

vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#EED8DA", bg = doomcolors.yellow })
vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#EED8DA", bg = doomcolors.yellow })
vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#EED8DA", bg = doomcolors.yellow })

vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = doomcolors.orange })
vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = doomcolors.orange })
vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = doomcolors.orange })

vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = doomcolors.blue })
vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = doomcolors.blue })
vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = doomcolors.blue })

vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = doomcolors.teal })
vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = doomcolors.teal })
vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = doomcolors.teal })
end,
  }
}
