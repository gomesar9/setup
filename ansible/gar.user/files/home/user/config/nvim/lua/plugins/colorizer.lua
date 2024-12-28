-- https://github.com/norcalli/nvim-colorizer.lua
return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			"*",
			css = { names = true },

			-- Exclude some filetypes from highlighting by using `!`
			-- '!vim'; -- Exclude vim from highlighting.
			-- Exclusion Only makes sense if '*' is specified!
		}, {
			names = false,
		})
	end,
}
