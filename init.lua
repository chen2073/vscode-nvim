vim.g.clipboard = vim.g.vscode_clipboard
vim.cmd("set clipboard=unnamedplus")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local vscode = require('vscode')

vim.keymap.set("n", "<C-z>", "<cmd>undo<cr>", { desc = "undo in normal mode"})
vim.keymap.set("n", "<leader>w", "a<space><esc>", { desc = "insert a whitespace after" })
vim.keymap.set("n", "<leader>ol", "o<esc>", { desc = "insert a empty line below"})
vim.keymap.set("n", "<leader>Ol", "O<esc>", { desc = "insert a empty line above"})
vim.keymap.set({ "n", "v" }, "bh", '"_', { desc = "backhole register" })

vim.keymap.set("n", "<C-f>", function() vscode.action("editor.find") end, { desc = "show search bar in normal mode" })

vim.keymap.set("n", "<leader>gaw", function()
    vscode.action("workbench.action.findInFiles", {
      args = { query = vim.fn.expand('<cword>') }
    })
end, { desc = "grep word in project scope"})

vim.keymap.set("v", "<leader>gas", function()
    vscode.action("workbench.action.findInFiles", {
      args = { query = vim.fn.expand('<cword>') }
    })
end, { desc = "grep word in project scope"})

vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "save file and back to normal mode" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      ---@type Flash.Config
      opts = {},
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      config = function ()
        require("nvim-treesitter.configs").setup({
          auto_install = true,
          indent = { enable = false },
          ensure_installed = { "lua" },
          sync_install = false,
          ignore_install = { "javascript" },
          highlight = {
            enable = false,
            disable = { "c" },
            additional_vim_regex_highlighting = false,
          },
        })
      end,
    },
    {
      'vscode-neovim/vscode-multi-cursor.nvim',
      event = 'VeryLazy',
      cond = not not vim.g.vscode,
      opts = {},
      config = function ()
        local cursors = require('vscode-multi-cursor')

        cursors.setup { -- Config is optional
          -- Whether to set default mappings
          default_mappings = true,
          -- If set to true, only multiple cursors will be created without multiple selections
          no_selection = false
        }

        vim.keymap.set({ 'n', 'x' }, 'mc', cursors.create_cursor, { expr = true, desc = 'Create cursor' })
        vim.keymap.set({ 'n' }, 'mcc', cursors.cancel, { desc = 'Cancel/Clear all cursors' })
        vim.keymap.set({ 'n', 'x' }, 'mi', cursors.start_left, { desc = 'Start cursors on the left' })
        vim.keymap.set({ 'n', 'x' }, 'mI', cursors.start_left_edge, { desc = 'Start cursors on the left edge' })
        vim.keymap.set({ 'n', 'x' }, 'ma', cursors.start_right, { desc = 'Start cursors on the right' })
        vim.keymap.set({ 'n', 'x' }, 'mA', cursors.start_right, { desc = 'Start cursors on the right' })
        vim.keymap.set({ 'n' }, '[mc', cursors.prev_cursor, { desc = 'Goto prev cursor' })
        vim.keymap.set({ 'n' }, ']mc', cursors.next_cursor, { desc = 'Goto next cursor' })
        vim.keymap.set({ 'n' }, 'mcs', cursors.flash_char, { desc = 'Create cursor using flash' })
        vim.keymap.set({ 'n' }, 'mcw', cursors.flash_word, { desc = 'Create selection using flash' })
      end
    },
  },
  checker = { enabled = true },
})