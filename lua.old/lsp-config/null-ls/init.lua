require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
  },
  defaults = {
    cmd = { "nvim" },
    debounce = 250,
    debug = false,
    default_timeout = 5000,
    diagnostic_config = nil,
    diagnostics_format = "#{m}",
    fallback_severity = vim.diagnostic.severity.ERROR,
    log_level = "warn",
    notify_format = "[null-ls] %s",
    on_attach = nil,
    on_init = nil,
    on_exit = nil,
    root_dir = require("null-ls.utils").root_pattern(".null-ls-root", "Makefile", ".git"),
    sources = nil,
    update_in_insert = false,
  },
})
