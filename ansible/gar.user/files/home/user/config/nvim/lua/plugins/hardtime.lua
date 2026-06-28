return {
	"m4xshen/hardtime.nvim",
	lazy = false,
	dependencies = { "MunifTanjim/nui.nvim" },
	opts = {
		restricted_keys = {
			["h"] = false,
			["j"] = false,
			["k"] = false,
			["l"] = false,
			["+"] = { "n", "x" },
			["gj"] = { "n", "x" },
			["gk"] = { "n", "x" },
			["<C-M>"] = { "n", "x" },
			["<C-N>"] = { "n", "x" },
			["<C-P>"] = { "n", "x" },
		},
	},
}
