vim.g.clipboard = vim.g.vscode_clipboard
vim.cmd("set clipboard=unnamedplus")

vim.g.mapleader = " "

local vscode = require('vscode')

vim.keymap.set("n", "<C-z>", "<cmd>undo<cr>", { desc = "undo in normal mode"})
vim.keymap.set("n", "<leader>w", "a<space><esc>", { desc = "insert a whitespace after" })
vim.keymap.set("n", "<leader>ol", "o<esc>", { desc = "insert a empty line below"})
vim.keymap.set("n", "<leader>Ol", "O<esc>", { desc = "insert a empty line above"})

vim.keymap.set("n", "<C-f>", function() vscode.action("editor.action.find") end, { desc = "show search bar in normal mode" })

vim.keymap.set("n", "<leader>gaw", function()
    vscode.action("workbench.action.findInFiles", {
        args = { query = vim.fn.expand('<cword>') }
    })
end, { desc = "grep word in project scope"})

vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "save file and back to normal mode" })

-- vim.keymap.set("v", )
