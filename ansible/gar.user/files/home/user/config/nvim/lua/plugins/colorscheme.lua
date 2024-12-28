-- https://github.com/folke/tokyonight.nvim
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
	},

	config = function()
		require("tokyonight").setup({
			-- use a random style

			style = (function()
				math.randomseed(os.time())
				local randi = math.random(1, 10)
				if randi < 5 then
					return "night"
				elseif randi < 8 then
					return "moon"
				else
					return "storm"
				end
			end)(),
			-- use a hour based style
			-- style = (function()
			-- 	-- usa estilo conforme hora do dia (UTC)
			-- 	local hour = tonumber(os.date("%H"))
			-- 	if 21 <= hour or hour < 3 then
			-- 		-- vibes 18h - 0h
			-- 		return "night"
			-- 	elseif hour < 5 then
			-- 		-- madrugada  0h - 2h
			-- 		return "moon"
			-- 	elseif hour < 9 then
			-- 		-- va dormir 2h - 6h
			-- 		return "day"
			-- 	elseif hour < 21 then
			-- 		-- comercial 6h - 18h
			-- 		return "storm"
			-- 	else
			-- 	end
			-- end)(),

			-- disable italic for functions
			styles = {
				functions = {},
			},

			-- Change the "hint" color to the "orange" color, and make the "error" color bright red
			on_colors = function(colors)
				local util = require("tokyonight.util")
				colors.hint = colors.orange
				colors.error = "#ff0000"
				colors.bg_search = util.blend_bg(colors.info, 0.2)
			end,
		})
	end,
}
