vim.g.mapleader = " "

vim.keymap.set("i", "<C-s>", "<cmd>w<cr><Esc>", { desc = "insert mode, save file" })
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "normal mode, save file" })
vim.keymap.set("n", "<leader>w", "a<space><esc>", { desc = "normal mode, insert a whitespace" })