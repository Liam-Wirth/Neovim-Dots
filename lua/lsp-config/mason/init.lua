require("mason").setup({
	ui = {
		icons = {
			package_installed = "āļ",
			package_pending = "â",
			package_uninstalled = "â",
		},
	},
})
require("mason-lspconfig").setup({ automatic_installation = true }
)
local util = require("util")

require("mason-lspconfig").setup_handlers({
	function(server_name)
		local opts = {
			on_attach = util.on_attach,
			capabilities = util.capabilities,
			update_in_insert = true,
		}

		if server_name == "sumneko_lua" then
			opts.settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						globals = { "vim" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			}
		end

		require("lspconfig")[server_name].setup(opts)
	end,
})
