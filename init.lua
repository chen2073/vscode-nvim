-- vim.g.clipboard = vim.g.vscode_clipboard
-- vim.cmd("set clipboard=unnamedplus")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local vscode = require('vscode')

-- vim.keymap.set("n", "<C-z>", "<cmd>undo<cr>", { desc = "undo in normal mode" })
-- vim.keymap.set("n", "<C-r>", "<cmd>redo<cr>", { desc = "redo in normal mode"})
-- vim.keymap.set("n", "<leader>a", "a<space><esc>", { desc = "append a whitespace" })
-- vim.keymap.set("n", "<leader>i", "i<space><esc>", { desc = "insert a whitespace" })
-- vim.keymap.set("n", "<leader>o", "o<esc>", { desc = "insert a empty line below current line" })
-- vim.keymap.set("n", "<leader>O", "O<esc>", { desc = "insert a empty line above current line" })
-- vim.keymap.set({ "n", "v" }, "bh", '"_', { desc = "backhole register" })

-- vim.keymap.set("n", "<C-f>", function()
--   vscode.action("editor.action.startFindReplaceAction")
-- end, { desc = "quick replace in editor" })

-- vim.keymap.set("n", "<leader>gaw", function()
--   vscode.action("workbench.action.findInFiles", {
--     args = { query = vim.fn.expand('<cword>') }
--   })
-- end, { desc = "quick find current word in workbench" })

-- vim.keymap.set("n", "<leader>gw", function()
--   vscode.action("workbench.action.find")
-- end, { desc = "quick find in workbench" })

-- vim.keymap.set("n", "<leader>tw", function()
--   vscode.action("editor.action.trimTrailingWhitespace")
-- end, { desc = "trim trailing whitespace" })

-- vim.keymap.set("n", "<leader>fm", function()
--   vscode.action("editor.action.formatDocument")
-- end, { desc = "format entire file" })

-- vim.keymap.set("v", "<leader>gas", function()
--   local start_pos = vim.fn.getpos('v')
--   local end_pos = vim.fn.getpos('.')

--   local start_line = start_pos[2] - 1
--   local start_character = start_pos[3] - 1
--   local end_line = end_pos[2] - 1
--   local end_character = end_pos[3] - 1
--   -- range are zero-indexed where lua is 1-indexed
--   vscode.action("workbench.action.findInFiles", {
--     range = { start_line, start_character, end_line, end_character }
--   })
-- end, { desc = "grep current visual selection in workbench" })

-- vim.keymap.set("v", "<leader>fm", function()
--   local start_line = vim.fn.line("v") - 1
--   local end_line = vim.fn.line(".") - 1
--   vscode.action("editor.action.formatSelection", {
--     range = { start_line, end_line }
--   })
-- end, { desc = "format selection" })

-- vim.keymap.set("i", "<C-s>", "<cmd>w<cr><esc>", { desc = "save file and back to normal mode" })
-- vim.keymap.set("i", "<C-q>", function()
--   vim.cmd("stopinsert")
-- end, { desc = "back to normal mode from insert mode" })

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    -- vscode.action("errorLens.toggle")
    vscode.update_config("errorLens.enabled", false, "global")
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    -- vscode.action("errorLens.toggle")
    vscode.update_config("errorLens.enabled", true, "global")
  end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- {
    --   "folke/flash.nvim",
    --   event = "VeryLazy",
    --   opts = {},
    --   keys = {
    --     { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --     { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --     { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --     { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --   },
    --   config = function()
    --     local flash = require("flash").setup()
    --     vim.keymap.set({ 'n', 'x', 'o' }, 'f', function()
    --       flash.jump()
    --     end, { desc = "Flash", noremap = true })
    --   end
    -- },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      config = function()
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
      config = function()
        local cursors = require('vscode-multi-cursor')

        cursors.setup { -- Config is optional
          -- Whether to set default mappings
          default_mappings = true,
          -- If set to true, only multiple cursors will be created without multiple selections
          no_selection = false
        }

        vim.keymap.set({ "n", "x" }, "mc", cursors.create_cursor, { expr = true, desc = "Create cursor" })
        vim.keymap.set({ "n" }, "mcc", cursors.cancel, { desc = "Cancel/Clear all cursors" })
        vim.keymap.set({ "n", "x" }, "mi", cursors.start_left, { desc = "Start cursors on the left" })
        vim.keymap.set({ "n", "x" }, "mI", cursors.start_left_edge, { desc = "Start cursors on the left edge" })
        vim.keymap.set({ "n", "x" }, "ma", cursors.start_right, { desc = "Start cursors on the right" })
        vim.keymap.set({ "n", "x" }, "mA", cursors.start_right, { desc = "Start cursors on the right" })
        vim.keymap.set({ "n" }, "[mc", cursors.prev_cursor, { desc = "Goto prev cursor" })
        vim.keymap.set({ "n" }, "]mc", cursors.next_cursor, { desc = "Goto next cursor" })
        vim.keymap.set({ "n" }, "mcs", cursors.flash_char, { desc = "Create cursor using flash" })
        vim.keymap.set({ "n" }, "mcw", cursors.flash_word, { desc = "Create selection using flash" })
      end
    },
    {
      "kylechui/nvim-surround",
      version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({
          keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "<leader>sy",
            normal_cur = "<leader>ssy",
            normal_line = "<leader>Sy",
            normal_cur_line = "<leader>SSy",
            visual = "<leader>S",
            visual_line = "<leader>Sg",
            delete = "<leader>sd",
            change = "<leader>sc",
            change_line = "<leader>Sc",
          },
        })
      end
    }
  },
  checker = { enabled = true },
})
