local colors = require "doom-one.colors".dark
local glyphs = require "settings.glyphs"
local hl1 = ("highlight IndentBlankLineIndent1 guifg="..colors.red)
local hl2 = ("highlight IndentBlankLineIndent2 guifg="..colors.yellow.." gui=nocombine")
local hl3 = ("highlight IndentBlankLineIndent3 guifg="..colors.cyan.." gui=nocombine")
local hl4 = ("highlight IndentBlankLineIndent4 guifg="..colors.green.." gui=nocombine")
local hl5 = ("highlight IndentBlankLineIndent5 guifg="..colors.magenta.." gui=nocombine")
local hl6 = ("highlight IndentBlankLineIndent6 guifg="..colors.orange.." gui=nocombine")
require("indent_blankline").setup {
colors = require'doom-one.colors'.dark,
  vim.cmd(hl1),
  vim.cmd(hl2),
  vim.cmd(hl3),
  vim.cmd(hl4),
  vim.cmd(hl5),
  vim.cmd(hl6),
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


