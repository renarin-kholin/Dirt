require "nvchad.autocmds"

require("conform").setup {
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 3000,
    lsp_format = "fallback",
  },
}
