-- *.sh
local group = "shebang"
vim.api.nvim_create_augroup(group, { clear = true }) -- Create a group for sh

local function shellcmd(pattern, lhs, rh)
	local autocmd = vim.api.nvim_create_autocmd -- Create automcd

	autocmd("Filetype", {
		pattern = pattern,
		group = group,
		callback = function()
			vim.keymap.set("i", lhs, rh, { silent = true })
		end,
	})
end

shellcmd("sh", ",bash", "#!/bin/bash<CR><CR>")
shellcmd("sh", ",sh", "#!/bin/sh<CR><CR>")
shellcmd("python", ",py3", "#!/usr/bin/env python3<CR><CR>")
shellcmd("python", ",py2", "#!/usr/bin/env python2<CR><CR>")
shellcmd("python", ",pys", "#!/usr/bin/env python<CR><CR>")

-- Experimental
-- vim.api.nvim_create_autocmd("BufNewFile", {
-- 	pattern = "sh",
-- 	group = "shell",
-- 	command = "norm i#!/bin/bash<CR><CR>",
-- })
