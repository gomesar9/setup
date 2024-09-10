-- *.norg
local group = "neorg"
local autocmd = vim.api.nvim_create_autocmd -- Create automcd

vim.api.nvim_create_augroup(group, { clear = true }) -- Create a group for sh

local function neorgcmd(mode, lhs, rh, opts)
	local _opts = { silent = true }
	-- concatena tabelas priorizando o parâmetro
	for k, v in pairs(opts) do
		_opts[k] = v
	end
	autocmd("Filetype", {
		pattern = "norg",
		group = group,
		callback = function()
			vim.keymap.set(mode, lhs, rh, _opts)
		end,
	})
end

autocmd("Filetype", {
	pattern = "norg",
	group = group,
	command = "set conceallevel=2",
})

-- Lists

---- Unordered
neorgcmd("i", ",1u", "- ", { buffer = 0 })
neorgcmd("i", ",2u", "-- ", { buffer = 0 })
neorgcmd("i", ",3u", "--- ", { buffer = 0 })
neorgcmd("i", ",4u", "---- ", { buffer = 0 })
neorgcmd("i", ",5u", "----- ", { buffer = 0 })
neorgcmd("i", ",6u", "------ ", { buffer = 0 })

---- Ordered
neorgcmd("i", ",1o", "~ ", { buffer = 0 })
neorgcmd("i", ",2o", "~~ ", { buffer = 0 })
neorgcmd("i", ",3o", "~~~ ", { buffer = 0 })
neorgcmd("i", ",4o", "~~~~ ", { buffer = 0 })
neorgcmd("i", ",5o", "~~~~~ ", { buffer = 0 })
neorgcmd("i", ",6o", "~~~~~~ ", { buffer = 0 })

---- Headers
neorgcmd("i", ",1h", "* ", { buffer = 0 })
neorgcmd("i", ",2h", "** ", { buffer = 0 })
neorgcmd("i", ",3h", "*** ", { buffer = 0 })
neorgcmd("i", ",4h", "**** ", { buffer = 0 })
neorgcmd("i", ",5h", "***** ", { buffer = 0 })
neorgcmd("i", ",6h", "****** ", { buffer = 0 })

---- Checkboxes
neorgcmd("i", ",1c", "- ( ) ", { buffer = 0 })
neorgcmd("i", ",2c", "-- ( ) ", { buffer = 0 })
neorgcmd("i", ",3c", "--- ( ) ", { buffer = 0 })
neorgcmd("i", ",4c", "---- ( ) ", { buffer = 0 })
neorgcmd("i", ",5c", "----- ( ) ", { buffer = 0 })
neorgcmd("i", ",6c", "------ ( ) ", { buffer = 0 })

-- Other snippets

neorgcmd("i", ",cd", "@code<CR>@end<Esc>O    <++><Esc>kA ", { buffer = 0 })
neorgcmd("i", ",tb", "@table<CR>@end<Esc>O    <++><Esc>kA", { buffer = 0 })
