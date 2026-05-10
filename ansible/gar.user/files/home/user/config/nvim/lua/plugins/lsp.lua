return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"j-hui/fidget.nvim",
	},
	opts = {},
	config = function()
		require("fidget").setup({})
	end,
}
