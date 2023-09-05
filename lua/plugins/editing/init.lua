local kind= require("util.glyphs").kind

return {
  {
    "lervag/vimtex",
    --NOTE: this plugin needs to be explicitly NOT Lazy loaded, as it lazy loads itself upon entering a latex buffer
    lazy = false,
  },
  --[[
  {
     "smjonas/inc-rename.nvim",
     lazy = true,
     keys = "<leader>rn",
  }
  --]]
  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    lazy = true,
    cmd = "SymbolsOutlineOpen",
    keys = { { "<leader>es", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    opts = {
      -- add your options that should be passed to the setup() function here
      position = "right",
	 symbols = {
	     File = { icon = kind.File, hl = "@text.uri" },
	     Module = { icon = kind.Module, hl = "@namespace" },
	     Namespace = { icon = kind.Namespace, hl = "@namespace" },
	     Package = { icon = kind.Package, hl = "@namespace" },
	     Class = { icon = kind.Class, hl = "@type" },
	     Method = { icon = kind.Method, hl = "@method" },
	     Property = { icon = kind.Property, hl = "@method" },
	     Field = { icon = kind.Field, hl = "@field" },
	     Constructor = { icon = kind.Constructor, hl = "@constructor" },
	     Enum = { icon = kind.Enum, hl = "@type" },
	     Interface = { icon = kind.Interface, hl = "@type" },
	     Function = { icon = kind.Function, hl = "@function" },
	     Variable = { icon = kind.Variable, hl = "@constant" },
	     Constant = { icon = kind.Constant, hl = "@constant" },
	     String = { icon = kind.String, hl = "@string" },
	     Number = { icon = kind.Number, hl = "@number" },
	     Boolean = { icon = kind.Boolean, hl = "@boolean" },
	     Array = { icon = kind.Array, hl = "@constant" },
	     Object = { icon = "⦿", hl = "@type" },
	     Key = { icon = "🔐", hl = "@type" },
	     Null = { icon = kind.Null, hl = "@type" },
	     EnumMember = { icon = kind.EnumMember, hl = "@field" },
	     Struct = { icon = kind.Struct, hl = "@type" },
	     Event = { icon = kind.Event, hl = "@type" },
	     Operator = { icon = kind.Operator, hl = "@operator" },
	     TypeParameter = { icon = "𝙏", hl = "@parameter" },
	     Component = { icon = "", hl = "@function" },
	     Fragment = { icon = "", hl = "@constant" },
	},
    },
  },
 {
     "folke/edgy.nvim",
     init = function()
       vim.opt.laststatus = 3
       vim.opt.splitkeep = "screen"
     end,
     opts = {
       bottom = {
	 -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
	 {
	   ft = "toggleterm",
	   size = { height = 0.4 },
	   -- exclude floating windows
	   filter = function(buf, win)
	     return vim.api.nvim_win_get_config(win).relative == ""
	   end,
	 },
	 {
	   ft = "lazyterm",
	   title = "LazyTerm",
	   size = { height = 0.4 },
	   filter = function(buf)
	     return not vim.b[buf].lazyterm_cmd
	   end,
	 },
	 "Trouble",
	 { ft = "qf", title = "QuickFix" },
	 {
	   ft = "help",
	   size = { height = 20 },
	   -- only show help buffers
	   filter = function(buf)
	     return vim.bo[buf].buftype == "help"
	   end,
	 },
	 { ft = "spectre_panel", size = { height = 0.4 } },
       },
       left = {
	 -- Neo-tree filesystem always takes half the screen height
	 {
	   title = "Neo-Tree",
	   ft = "neo-tree",
	   filter = function(buf)
	     return vim.b[buf].neo_tree_source == "filesystem"
	   end,
	   size = { height = 0.5 },
	 },
	 {
	   title = "Neo-Tree Git",
	   ft = "neo-tree",
	   filter = function(buf)
	     return vim.b[buf].neo_tree_source == "git_status"
	   end,
	   pinned = true,
	   open = "Neotree position=right git_status",
	 },
	 {
	   title = "Neo-Tree Buffers",
	   ft = "neo-tree",
	   filter = function(buf)
	     return vim.b[buf].neo_tree_source == "buffers"
	   end,
	   pinned = false,
	   open = "Neotree position=top buffers",
	 },
	 {
	   ft = "Outline",
	   pinned = true,
	   open = "SymbolsOutlineOpen",
	 },
	 -- any other neo-tree windows
	 "neo-tree",
       },
     },
   },
   {
  "j-hui/fidget.nvim",
  tag = "legacy",
  event = "LspAttach",
  opts = {
    -- options
  },
}
}
