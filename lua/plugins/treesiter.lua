return {
	"nvim-treesitter/nvim-treesitter",
	-- event = { "BufReadPre", "BufNewFile" },
	event = "VeryLazy",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitignore",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-j>",
					node_incremental = "<C-j>",
					scope_incremental = false,
					node_decremental = "<C-k>",
				},
			},
			rainbow = {
				enable = true,
				disable = { "html" },
				extended_mode = false,
				max_file_lines = nil,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
