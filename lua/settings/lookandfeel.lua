local colors = require "doom-one.colors".dark
local glyphs = require "settings.glyphs"
local hl1 = ("highlight IndentBlankLineIndent1 guifg="..colors.red.." gui=nocombine")
local hl2 = ("highlight IndentBlankLineIndent2 guifg="..colors.yellow.." gui=nocombine")
local hl3 = ("highlight IndentBlankLineIndent3 guifg="..colors.cyan.." gui=nocombine")
local hl4 = ("highlight IndentBlankLineIndent4 guifg="..colors.green.." gui=nocombine")
local hl5 = ("highlight IndentBlankLineIndent5 guifg="..colors.magenta.." gui=nocombine")
local hl6 = ("highlight IndentBlankLineIndent6 guifg="..colors.orange.." gui=nocombine")

local font = "JetBrainsMonoExtraBold"..[[\ ]].."Nerd"..[[\ ]].."Font:h16"
--cursed fucking workaround to get tab to show
local escape = [[\ \]]

local lookandfeel = {
--TODO Unfuck all of this, and make things more consice and easier to find/figure out
--TODO get 

--personally I really hate the look of having whitespace have the little dots, but it's an option if you want it I guess
    --vim.opt.listchars:append "space:⋅",
--tab:'
vim.cmd('set listchars=eol:'..'↩'..',tab:'..escape..''),


--indent blankline
require("indent_blankline").setup {
colors = require'doom-one.colors'.dark,
hl1 = ("highlight IndentBlankLineIndent1 guifg="..colors.red),
hl2 = ("highlight IndentBlankLineIndent2 guifg="..colors.yellow.." gui=nocombine"),
hl3 = ("highlight IndentBlankLineIndent3 guifg="..colors.cyan.." gui=nocombine"),
hl4 = ("highlight IndentBlankLineIndent4 guifg="..colors.green.." gui=nocombine"),
hl5 = ("highlight IndentBlankLineIndent5 guifg="..colors.magenta.." gui=nocombine"),
hl6 = ("highlight IndentBlankLineIndent6 guifg="..colors.orange.." gui=nocombine"),
  vim.cmd(hl1),
  vim.cmd(hl2),
  vim.cmd(hl3),
  vim.cmd(hl4),
  vim.cmd(hl5),
    space_char_blankline = glyphs.ui.LineLeft,
    show_current_context = true,
    show_current_context_start = true,
     char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
  use_treesitter = true,
},


--this is for Neovide
vim.cmd([[
    if exists("g:neovide")
      set guifont=]]..font..[[

]]),
--enable Colorizer
--vim.cmd[[ColorizerAttachToBuffer]]
  require("colorizer").setup {
      filetypes = { "*" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        virtualtext = "■",
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = 'foreground', -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { css }, }, -- Enable sass colors
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
  },
--NOTE decided to move the stuff that would be in the "Look and Feel" file here?
--TODO f
--TODO figure out a way to get this to work so that I don't have to have them here
}
vim.opt.list = true
return lookandfeel

