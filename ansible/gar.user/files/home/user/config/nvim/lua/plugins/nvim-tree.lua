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
			-- Keymaps locais ao buffer da árvore.
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				-- Preserva os mapeamentos default do nvim-tree.
				api.map.on_attach.default(bufnr)

				-- `W` (default) colapsa desde a raiz; `w` colapsa só o node atual.
				-- Keymap não mescla opts: `silent` precisa ser explícito aqui.
				Keymap("n", "w", api.node.collapse, {
					buffer = bufnr,
					silent = true,
					nowait = true,
					desc = "nvim-tree: Collapse Current",
				})
			end,
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
