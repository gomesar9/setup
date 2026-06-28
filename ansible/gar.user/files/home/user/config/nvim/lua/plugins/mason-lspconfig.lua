return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	opts = {
		automatic_enable = true,
		ensure_installed = {
			"ansiblels",
			"bashls",
			"eslint",
			"gopls",
			"lua_ls",
			"rust_analyzer",
		},
	},
}
