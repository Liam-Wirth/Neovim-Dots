local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
-- luasnip setup
ls.filetype_extend("all", { "_" })
ls.filetype_extend("<luasnip-filetype>", { "<collection-filetype>" })
require("luasnip.loaders.from_vscode").load({paths = "~/.config/nvim/lua/lsp-config/snippets/","~/.config/nvim/lua/lsp-config/snippets/*"})
--ls.add_snippets("java", {	-- Very long example for a java class.
--	s("fn", {
--		d(6, jdocsnip, { 2, 4, 5 }),
--		t({ "", "" }),
--		c(1, {
--			t("public "),
--			t("private "),
--		}),
--		c(2, {
--			t("void"),
--			t("String"),
--			t("char"),
--			t("int"),
--			t("double"),
--			t("boolean"),
--			i(nil, ""),
--		}),
--		t(" "),
--		i(3, "myFunc"),
--		t("("),
--		i(4),
--		t(")"),
--		c(5, {
--			t(""),
--			sn(nil, {
--				t({ "", " throws " }),
--				i(1),
--			}),
--		}),
--		t({ " {", "\t" }),
--		i(0),
--		t({ "", "}" }),
--	}),
--}, {
--	key = "java",
--})
local luaconf = vim.fn.stdpath('config')..'/lua'
require("luasnip.loaders.from_lua").lazy_load("~/.config/nvim/lua/lsp-config/snippets/" )
