vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local vscode = require("vscode")

vim.g.clipboard = vim.g.vscode_clipboard

-- vim.keymap.set('n', 'X', '"_x', { desc = 'Delete char to black hole register', noremap = true })
-- vim.keymap.set('v', 'X', '"_d', { desc = 'Delete selection to black hole register' })
-- vim.keymap.set('n', 'XX', '"_dd', { desc = 'Delete line to black hole register' })

vim.keymap.set('n', '<leader>m', function()
    local content = vim.fn.getreg('"')
    local regtype = vim.fn.getregtype('"')
    vim.fn.setreg('*', content, regtype)
    print("Copied to system clipboard")
end, { desc = 'Copy unnamed register to system clipboard' })

-- vim.keymap.set({ "n", "i", "v" }, "<C-f>", function()
--     vscode.action("editor.action.startFindReplaceAction")
-- end, { desc = "quick replace in editor" })

-- vim.keymap.set("n", "<leader>gaw", function()
--   vscode.action("workbench.action.findInFiles", {
--     args = { query = vim.fn.expand("<cword>") }
--   })
-- end, { desc = "quick find current word in workbench" })

-- vim.keymap.set("n", "<leader>gw", function()
--   vscode.action("workbench.action.find")
-- end, { desc = "quick find in workbench" })

vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", { desc = "Save and exit to normal mode" })

vim.keymap.set("n", "<leader>t", function()
    vscode.action("editor.action.trimTrailingWhitespace")
    print("Trimmed trailing whitespace")
end, { desc = "trim trailing whitespace" })

vim.keymap.set("n", "<leader>fm", function()
    vscode.action("editor.action.formatDocument")
    print("Formatted document")
end, { desc = "format document" })

vim.keymap.set("v", "<leader>fm", function()
    local start_line = vim.fn.line("v") - 1
    local end_line = vim.fn.line(".") - 1
    vscode.action("editor.action.formatSelection", {
        range = { start_line, end_line }
    })
    print("Formated visual selection")
end, { desc = "format visual selection" })

-- vim.keymap.set("v", "<leader>gas", function()
--   local start_pos = vim.fn.getpos("v")
--   local end_pos = vim.fn.getpos(".")

--   local start_line = start_pos[2] - 1
--   local start_character = start_pos[3] - 1
--   local end_line = end_pos[2] - 1
--   local end_character = end_pos[3] - 1
--   -- range are zero-indexed where lua is 1-indexed
--   vscode.action("workbench.action.findInFiles", {
--     range = { start_line, start_character, end_line, end_character }
--   })
-- end, { desc = "grep current visual selection in workbench" })

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        -- vscode.action("errorLens.toggle")
        vscode.update_config("errorLens.enabled", false, "global")
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
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
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            opts = {},
            keys = {
                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
                { "r", mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
                -- { "R", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            },
            config = function()
                local flash = require("flash")
                flash.setup()
                vim.api.nvim_create_user_command("ToggleFlash", function()
                    flash.toggle()
                    print("flash toggled")
                end, { desc = "Toggle flash on/off" })
            end
        },
        -- {
        --     "nvim-treesitter/nvim-treesitter",
        --     build = ":TSUpdate",
        --     config = function()
        --         require("nvim-treesitter.configs").setup({
        --             auto_install = false,
        --             indent = { enable = false },
        --             ensure_installed = { "lua" },
        --             sync_install = false,
        --             ignore_install = { "javascript" },
        --             highlight = {
        --                 enable = false,
        --                 disable = { "c" },
        --                 additional_vim_regex_highlighting = false,
        --             },
        --         })
        --     end,
        -- },
        -- {
        --     "nvim-treesitter/nvim-treesitter-textobjects",
        --     event = "VeryLazy",
        --     enabled = true,
        --     config = function()
        --         require("nvim-treesitter.configs").setup({
        --             textobjects = {
        --                 select = {
        --                     enable = true,

        --                     -- Automatically jump forward to textobj, similar to targets.vim
        --                     lookahead = true,

        --                     keymaps = {
        --                         -- You can use the capture groups defined in textobjects.scm
        --                         ["af"] = "@function.outer",
        --                         ["if"] = "@function.inner",
        --                         ["ac"] = "@class.outer",
        --                         -- You can optionally set descriptions to the mappings (used in the desc parameter of
        --                         -- nvim_buf_set_keymap) which plugins like which-key display
        --                         ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
        --                         -- You can also use captures from other query groups like `locals.scm`
        --                         ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        --                     },
        --                     -- You can choose the select mode (default is charwise "v")
        --                     --
        --                     -- Can also be a function which gets passed a table with the keys
        --                     -- * query_string: eg "@function.inner"
        --                     -- * method: eg "v" or "o"
        --                     -- and should return the mode ("v", "V", or "<c-v>") or a table
        --                     -- mapping query_strings to modes.
        --                     selection_modes = {
        --                         ["@parameter.outer"] = "v", -- charwise
        --                         ["@function.outer"] = "V",  -- linewise
        --                         ["@class.outer"] = "<c-v>", -- blockwise
        --                     },
        --                     -- If you set this to `true` (default is `false`) then any textobject is
        --                     -- extended to include preceding or succeeding whitespace. Succeeding
        --                     -- whitespace has priority in order to act similarly to eg the built-in
        --                     -- `ap`.
        --                     --
        --                     -- Can also be a function which gets passed a table with the keys
        --                     -- * query_string: eg "@function.inner"
        --                     -- * selection_mode: eg "v"
        --                     -- and should return true or false
        --                     include_surrounding_whitespace = true,
        --                 },
        --                 move = {
        --                     enable = true,
        --                     set_jumps = true, -- whether to set jumps in the jumplist
        --                     goto_next_start = {
        --                         ["]m"] = "@function.outer",
        --                         ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --                         --
        --                         -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
        --                         ["]o"] = "@loop.*",
        --                         -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --                         --
        --                         -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        --                         -- Below example nvim-treesitter"s `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        --                         ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
        --                         ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
        --                     },
        --                     goto_next_end = {
        --                         ["]M"] = "@function.outer",
        --                         ["]["] = "@class.outer",
        --                     },
        --                     goto_previous_start = {
        --                         ["[m"] = "@function.outer",
        --                         ["[["] = "@class.outer",
        --                     },
        --                     goto_previous_end = {
        --                         ["[M"] = "@function.outer",
        --                         ["[]"] = "@class.outer",
        --                     },
        --                     -- Below will go to either the start or the end, whichever is closer.
        --                     -- Use if you want more granular movements
        --                     -- Make it even more gradual by adding multiple queries and regex.
        --                     goto_next = {
        --                         ["]d"] = "@conditional.outer",
        --                     },
        --                     goto_previous = {
        --                         ["[d"] = "@conditional.outer",
        --                     }
        --                 },
        --             },
        --         })
        --     end
        -- },
        {
            "vscode-neovim/vscode-multi-cursor.nvim",
            event = "VeryLazy",
            cond = not not vim.g.vscode,
            opts = {},
            config = function()
                local cursors = require("vscode-multi-cursor")

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
            version = "^3.0.0",
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup({})
            end
        },
        -- {
        --     "gbprod/yanky.nvim",
        --     opts = {
        --         ring = { storage = "memory" },
        --     },
        --     keys = {
        --         { "<leader>p", "<cmd>YankyRingHistory<cr>",              mode = { "n", "x" },                                desc = "Open Yank History" },
        --         { "y",         "<Plug>(YankyYank)",                      mode = { "n", "x" },                                desc = "Yank text" },
        --         { "p",         "<Plug>(YankyPutAfter)",                  mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
        --         { "P",         "<Plug>(YankyPutBefore)",                 mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
        --         { "gp",        "<Plug>(YankyGPutAfter)",                 mode = { "n", "x" },                                desc = "Put yanked text after selection" },
        --         { "gP",        "<Plug>(YankyGPutBefore)",                mode = { "n", "x" },                                desc = "Put yanked text before selection" },
        --         { "<c-p>",     "<Plug>(YankyPreviousEntry)",             desc = "Select previous entry through yank history" },
        --         { "<c-n>",     "<Plug>(YankyNextEntry)",                 desc = "Select next entry through yank history" },
        --         { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
        --         { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
        --         { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",    desc = "Put indented after cursor (linewise)" },
        --         { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",   desc = "Put indented before cursor (linewise)" },
        --         { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",  desc = "Put and indent right" },
        --         { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",   desc = "Put and indent left" },
        --         { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
        --         { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",  desc = "Put before and indent left" },
        --         { "=p",        "<Plug>(YankyPutAfterFilter)",            desc = "Put after applying a filter" },
        --         { "=P",        "<Plug>(YankyPutBeforeFilter)",           desc = "Put before applying a filter" },
        --     },
        -- }
    },
    checker = { enabled = true },
})
