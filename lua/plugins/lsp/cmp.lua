local vim = vim
return {
   {
      "hrsh7th/nvim-cmp",
      version = false, -- last release is way too old
      event = "BufReadPre",
      dependencies = {
         { "hrsh7th/cmp-nvim-lsp" },
         { "hrsh7th/cmp-nvim-lua" },
         { "hrsh7th/cmp-buffer" },
         { "hrsh7th/cmp-path" },
         { "hrsh7th/cmp-cmdline" },
         { "hrsh7th/cmp-calc" },
         {
            "rafamadriz/friendly-snippets",
            config = function()
               require("luasnip.loaders.from_vscode").lazy_load()
            end,
         },
         { "saadparwaiz1/cmp_luasnip" },
         { "hrsh7th/cmp-omni" },
         { "onsails/lspkind-nvim",    module = "lspkind" }
      },
      opts = function()
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
               { name = "nvim_lsp",             priority = 10 },
               { name = "luasnip",              priority = 9 }, -- Force snippet/lsp suggestions to the top
               { name = "nvim-lua" },
               { name = "crates" },
               -- { name = "vim-dadbod-completion" },
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
               ghost_text = false,
            },
            window = {
               completion = cmp.config.window.bordered({
                  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                  col_offset = -3,
                  side_padding = 0,
               }),
               documentation = cmp.config.window.bordered({
                  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
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

                  local menu_icon = {
                     luasnip = "[LuaSnip]",
                     nvim_lua = "[Lua]",
                     calc = " 󰃬 ",
                  }
                  if entry.source.name == "calc" then
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
            --TODO: add these bindings to Whichkey
            mapping = {
               ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
               ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
               ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i",
                  "c" }),
               ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                  { "i", "c" }),
               ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                  { "i", "c" }),
               ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                  { "i", "c" }),
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
               ["<C-p>"] = cmp.mapping({
                  i = function()
                     if cmp.visible() then
                        cmp.abort()
                        require("util.init").toggle_completion()
                     else
                        cmp.complete()
                        require("util.init").toggle_completion()
                     end
                  end,
               }),
               ["<C-<CR>>"] = cmp.mapping({
                  i = function(fallback)
                     if cmp.visible() then
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                        require("util").toggle_completion()
                     else
                        fallback()
                     end
                  end,
               }),
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
      end,
   }
}
