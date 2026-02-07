require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map({ "n", "v", "o" }, "<leader>1", "^", { noremap = true, silent = true })
map({ "n", "v", "o" }, "<leader>2", "$", { noremap = true, silent = true })
map("t", "<ESC>", "<C-\\><C-n>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
