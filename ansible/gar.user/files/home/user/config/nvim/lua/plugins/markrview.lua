return {
	"OXY2DEV/markview.nvim",
	lazy = true, -- Recommended
	version = "v28.2.0",
	-- ft = "markdown" -- If you decide to lazy-load anyway

	dependencies = {
		-- "nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local markview = require("markview")
		markview.setup({
			preview = {
				enable = false,
			},
		})

		-- Tive que gerenciar manualmente após o splitToggle
		-- senão o followup não acontece.
		Keymap("n", "<leader>mst", function()
			markview.commands.splitToggle()
			if markview.state.splitview_source ~= nil then
				markview.commands.Enable()
			else
				markview.commands.Disable()
			end
		end, { desc = "splitToggle" })

		Keymap("n", "<leader>mt", markview.commands.toggle, { desc = "toggleAll" })
	end,
}
