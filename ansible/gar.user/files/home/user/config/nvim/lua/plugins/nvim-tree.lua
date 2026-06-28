return {
	"nvim-tree/nvim-tree.lua",
	version = "v1.17.0",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		nvimtree.setup({
			view = {
				width = 40,
			},
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			git = {
				ignore = false,
			},
		})

		-- Set keymaps using custom function Keymap
		Keymap("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>")
		Keymap("n", "<leader>et", "<cmd>NvimTreeFindFile<CR>")
		Keymap("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>")
		Keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")
		Keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
	end,
	lazy = false,
}
