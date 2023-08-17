require("lspconfig").lua_ls.setup({settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            disable = { "incomplete-signature-doc", "trailing-space" },
                            -- enable = false,
                            groupSeverity = {
                              strong = "Warning",
                              strict = "Warning",
                            },
                            globals = {
                                "vim",
                                "require",
                            },
                            groupFileStatus = {
                                ["ambiguity"] = "Opened",
                                ["await"] = "Opened",
                                ["codestyle"] = "None",
                                ["duplicate"] = "Opened",
                                ["global"] = "Opened",
                                ["luadoc"] = "Opened",
                                ["redefined"] = "Opened",
                                ["strict"] = "Opened",
                                ["strong"] = "Opened",
                                ["type-check"] = "Opened",
                                ["unbalanced"] = "Opened",
                                ["unused"] = "Opened",
                              },
                              unusedLocalExclude = { "_*" },
                        },
                        type = {
                            castNumberToInteger = true,
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false
                        },
                        doc = {
                            privateName = { "^_" },
                        },
                        format = {
                            enable = true,
                            default_config = {
                                indent_style = "space",
                                indent_size = "2",
                                continuation_indent_size = "2",
                            },
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

       vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil,{focusable=false,scope="cursor"})]])
      ---@type table<string>
       local diagnostics = require("util.glyphs").diagnostics
      local signs = {
	 Error = diagnostics.BoldError,
	 Warn = diagnostics.BoldWarning,
	 Hint = diagnostics.BoldHint,
	 Info = diagnostics.BoldInformation,
      }
      for type, icon in pairs(signs) do
	 local hl = "DiagnosticSign" .. type
	 vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
local ret = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
      { "folke/neodev.nvim", opts = {} },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    lazy = true,
    --NOTE: Stolen straight from folkes dots, apparently improves performance
    init = function()
        -- disable lsp watcher. Too slow on linux
        local ok, wf = pcall(require, "vim.lsp._watchfiles")
        if ok then
          wf._watchfunc = function()
            return function() end
          end
        end
      end,
    opts = {
        inlay_hints = { enabled = true },
        servers = {
            bashls = {},
            clangd = {},
            rust_analyzer = {
                settings = {
                   ["rust-analyzer"] = {
                  --   procMacro = { enable = true },
                  --   cargo = { allFeatures = true },
                  --   checkOnSave = {
                  --     command = "clippy",
                  --     extraArgs = { "--no-deps" },
                     },
                   },
                 },
            lua_ls = {
                single_file_support = true,
                vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float(nil,{focusable=false,scope="cursor"})]])
            },
            vimls = {},
        },
        setup = {},
    },
}
vim.keymap.set("n", "<leader>.", function()
      vim.lsp.buf.format({ async = true })
   end
   )
return ret
