return {
    "nvim-telescope/telescope.nvim",
    tag = "0.2.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = { "^node_modules/" },
            },
        })

        -- Set keymaps using custom function Keymap
        local builtin = require("telescope.builtin")
        Keymap("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy [f]ind files in cwd" })
        Keymap("n", "<leader>fg", builtin.live_grep, { desc = "Fuzzy [g]rep live in cwd" })
        Keymap("n", "<leader>fs", builtin.grep_string, { desc = "Find [s]tring under cursor in cwd" })
        Keymap("n", "<leader>fb", builtin.builtin, { desc = "Find [b]uiltins" })
        Keymap("n", "<leader>fw", builtin.lsp_workspace_symbols, { desc = "Find [w]orkspace symbols" })
    end,
}
