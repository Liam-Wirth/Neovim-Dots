return{
    "mhartington/formatter.nvim", -- auto reformatter,
    lazy = true,
    event = {"BufWritePre"},
    opts = {
      require("formatter").setup({
        filetype = {
          lua = {
            require("formatter.filetypes.lua").stylua(),
          },
          rust = {
            require("formatter.filetypes.rust").rustfmt,
          },
          go = {
            require("formatter.filetypes.go").gofmt,
          },
          ["*"] = {
            require("formatter.filetypes.any").remove_trailing_whitespace,
          },
        },
      })
    },
    cmd = "Format",
}
