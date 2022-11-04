local colors = require "doom-one.colors".dark
local glyphs = require "settings.glyphs"



--TODO Unfuck all of this, and make things more consice and easier to find/figure out
--TODO get 
vim.opt.list = true

--personally I really hate the look of having whitespace have the little dots, but it's an option if you want it I guess
    --vim.opt.listchars:append "space:⋅",
--tab:'
local escape = [[\ \]]
  --cursed fucking workaround to get tab to show
vim.cmd('set listchars=eol:'..'↩'..',tab:'..escape..'')
local hl1 = ("highlight IndentBlankLineIndent1 guifg="..colors.red.." gui=nocombine")
local hl2 = ("highlight IndentBlankLineIndent2 guifg="..colors.yellow.." gui=nocombine")
local hl3 = ("highlight IndentBlankLineIndent3 guifg="..colors.cyan.." gui=nocombine")
local hl4 = ("highlight IndentBlankLineIndent4 guifg="..colors.green.." gui=nocombine")
local hl5 = ("highlight IndentBlankLineIndent5 guifg="..colors.magenta.." gui=nocombine")
local hl6 = ("highlight IndentBlankLineIndent6 guifg="..colors.orange.." gui=nocombine")
  vim.cmd(hl1)
  vim.cmd(hl2)
  vim.cmd(hl3)
  vim.cmd(hl4)
  vim.cmd(hl5)
  vim.cmd(hl6)


--indent blankline
require("indent_blankline").setup {
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
}


--this is for Neovide
local font = "JetBrainsMonoExtraBold"..[[\ ]].."Nerd"..[[\ ]].."Font:h16"
vim.cmd([[
    if exists("g:neovide")
      set guifont=]]..font..[[

]])
--enable Colorizer
--vim.cmd[[ColorizerAttachToBuffer]]
require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      })
