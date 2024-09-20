ret = {
   require("conform").setup({
      formatters_by_ft = {
         python = { "isort", "black" },
         py = { "black" },
         bash = { "shellcheck" },
         javascript = { "prettier" },
         typescript = { "prettier" },
         markdown = { "prettier" },
         html = { "prettier" },
      }
   })
}

return ret
