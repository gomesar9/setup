return {
	"nvim-neorg/neorg",
	build = ":Neorg sync-parsers",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {
					config = {
						icon_preset = "basic", --basic, diamonds, varied
						adaptive = true,
						conceal = true,
						content_only = true,
						padding = 10,
					},
				},
				["core.completion"] = { config = { engine = "nvim-cmp" } },
				["core.dirman"] = {
					config = {
						workspaces = {
							personal = "~/notes/gomes",
							work = "~/notes/work",
						},
						index = "index.norg",
						default_workspace = "personal",
						open_last_workspace = false,
					},
				},
			},
		})
	end,
}
