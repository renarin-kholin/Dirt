require("nvchad.configs.lspconfig").defaults()

local servers = {
  html = {},
  cssls = {},
  gopls = {},
  marksman = {},
  astro = {},
  tailwindcss = {
    root_markers = { "tailwind.config.js", "tailwind.config.ts" },
  },
  -- angularls = {
  --   root_markers = { "angular.json" },
  -- },
  jdtls = {},
  slint_lsp = {},
  ruff_lsp = {},
  ts_ls = {
    root_markers = { "package.json" },
    single_file_support = false,
  },
  denols = {
    root_markers = { "deno.json", "deno.jsonc" },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end
-- read :h vim.lsp.config for changing options of lsp servers
vim.g.markdown_fenced_languages = {
  "ts=typescript",
}
