require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "gopls",
  "marksman",
  "ts_ls",
  "rust_analyzer",
  "astro",
  "tailwindcss",
  "angularls",
}
vim.lsp.enable(servers)
-- read :h vim.lsp.config for changing options of lsp servers
