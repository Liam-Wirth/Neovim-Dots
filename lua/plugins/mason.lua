return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    lazy = false,
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
       "lua-language-server",
        -- "flake8",
      },
    },
---    config = function(_, opts)
---      require("mason").setup(opts)
---      local mr = require("mason-registry")
---      local function ensure_installed()
---        for _, tool in ipairs(opts.ensure_installed) do
---          local p = mr.get_package(tool)
---          if not p:is_installed() then
---            p:install()
---          end
---        end
---      end
---      if mr.refresh then
---        mr.refresh(ensure_installed)
---      else
---        ensure_installed()
---      end
---    end,
  },
  {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
   config = function()
      ensure_installed = {
       "lua-language-server",
      }
   end
  }
}
