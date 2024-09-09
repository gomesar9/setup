return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("telescope").setup()

		-- Set keymaps using custom function Keymap
		Keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		Keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Fuzzy find recent files" })
		Keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })
		Keymap("n", "<leader>fs", "<cmd>Telescope git_status<cr>", { desc = "Find string under cursor in cwd" })
		Keymap("n", "<leader>fc", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })
	end,
}
