return {
	"neovim/nvim-lspconfig",
	version = "2.10.0",
	dependencies = {
		"j-hui/fidget.nvim",
	},
	opts = {},
	config = function()
		require("fidget").setup({})
	end,
}
