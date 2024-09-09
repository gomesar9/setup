-- *.sh
local group = "neorg"
local autocmd = vim.api.nvim_create_autocmd -- Create automcd

vim.api.nvim_create_augroup(group, { clear = true }) -- Create a group for sh

-- local function shellcmd(pattern, lhs, rh)
-- 	autocmd("Filetype", {
-- 		pattern = pattern,
-- 		group = group,
-- 		command = "",
-- 		callback = function()
-- 			vim.keymap.set("i", lhs, rh, { silent = true })
-- 		end,
-- 	})
-- end

autocmd("Filetype", {
	pattern = "",
	group = group,
	command = "set conceallevel=2",
})
