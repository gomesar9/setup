return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		nvimtree.setup({
			view = {
				width = 60,
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
		Keymap("n", "<leader>ef", "<cmd>NvimFindFileToggle<CR>")
		Keymap("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>")
		Keymap("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>")
	end,
	lazy = true,
}
