-- Completion engine: blink.cmp (replaced nvim-cmp 2026-07-17).
-- Rust fuzzy matcher, built-in LSP/path/snippets/buffer/cmdline sources and
-- signature help -- replaces the old cmp-* plugin forest and lspkind.
local ret = {
   {
      "saghen/blink.cmp",
      version = "1.*", -- required for the prebuilt fuzzy-matcher binary
      event = { "InsertEnter", "CmdlineEnter" },
      dependencies = {
         "L3MON4D3/LuaSnip",
         "folke/lazydev.nvim",
      },
      opts = {
         -- <Tab> accepts the selected item (matches old cmp behavior),
         -- falls back to snippet jump, then to literal tab.
         keymap = {
            preset = "super-tab",
            ["<C-j>"] = { "select_next", "fallback" },
            ["<C-k>"] = { "select_prev", "fallback" }, -- menu closed -> falls through to signature help
            ["<C-d>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-space>"] = { "show", "fallback" },
            ["<C-e>"] = { "hide", "fallback" },
         },
         snippets = { preset = "luasnip" },
         sources = {
            default = { "lazydev", "lsp", "snippets", "path", "buffer" },
            providers = {
               lazydev = {
                  name = "LazyDev",
                  module = "lazydev.integrations.blink",
                  score_offset = 100, -- prefer lua type completions over lsp
               },
            },
         },
         completion = {
            -- preselect first item but don't insert until confirmed (old
            -- completeopt=menu,menuone,noinsert behavior)
            list = { selection = { preselect = true, auto_insert = false } },
            documentation = { auto_show = true, auto_show_delay_ms = 200 },
            menu = { border = "rounded" },
         },
         signature = { enabled = true, window = { border = "rounded" } },
         cmdline = {
            enabled = true,
            keymap = { preset = "cmdline" },
            completion = { menu = { auto_show = true } },
         },
         appearance = { nerd_font_variant = "mono" },
      },
      opts_extend = { "sources.default" },
   },
   {
      "L3MON4D3/LuaSnip",
      dependencies = {
         "rafamadriz/friendly-snippets",
      },
      config = function(_, opts)
         require("luasnip").setup(opts)
         require("luasnip.loaders.from_vscode").lazy_load()
         require("luasnip.loaders.from_lua").load({
            paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
         })
      end,
      opts = {
         history = true,
         delete_check_events = "TextChanged",
      },
   },
}

if not vim.g.vscode then
   return ret
end
