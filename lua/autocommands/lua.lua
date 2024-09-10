-- *.lua
local group = "lua"
local autocmd = vim.api.nvim_create_autocmd -- Create automcd

vim.api.nvim_create_augroup(group, { clear = true }) -- Create a group for sh

-- local function neorgcmd(mode, lhs, rh, opts)
-- 	local _opts = { silent = true }
-- 	-- concatena tabelas priorizando o parâmetro
-- 	for k, v in pairs(opts) do
-- 		_opts[k] = v
-- 	end
-- 	autocmd("Filetype", {
-- 		pattern = "lua",
-- 		group = group,
-- 		callback = function()
-- 			vim.keymap.set(mode, lhs, rh, _opts)
-- 		end,
-- 	})
-- end

autocmd("Filetype", {
	pattern = "lua",
	group = group,
	command = "set noexpandtab copyindent shiftwidth=4",
})
