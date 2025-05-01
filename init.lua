vim.g.clipboard = vim.g.vscode_clipboard
vim.cmd("set clipboard=unnamedplus")

vim.g.mapleader = " "

vim.keymap.set("n", "<C-z>", "<cmd>undo<cr>", { desc = "undo in normal mode"})
vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "insert mode, save file" })
vim.keymap.set("n", "<leader>w", "a<space><esc>", { desc = "normal mode, insert a whitespace" })