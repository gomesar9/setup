vim.g.mapleader = " "

-- Enable the option to require a Prettier config file
-- If no prettier config file is found, the formatter will not be used
vim.g.lazyvim_prettier_needs_config = false

-- Save
Keymap("n", "<leader>w", "<CMD>update<CR>")
-- Exit
Keymap("n", "<leader>pv", vim.cmd.Ex)

-- Abbreviations
vim.cmd("cnoreabbrev  Q      q")
vim.cmd("cnoreabbrev  Q!     q!")
--vim.cmd("cnoreabbrev  Qall   qall")
--vim.cmd("cnoreabbrev  Qall!  qall!")
vim.cmd("cnoreabbrev  W      w")
vim.cmd("cnoreabbrev  W!     w!")
vim.cmd("cnoreabbrev  WQ     wq")
vim.cmd("cnoreabbrev  Wa     wa")
vim.cmd("cnoreabbrev  Wq     wq")
vim.cmd("cnoreabbrev  wQ     wq")

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces

-- PyEnv TODO: Only python files
vim.env.PYENV_VERSION = vim.fn.system("pyenv version"):match("(%S+)%s+%(.-%)")

-- LazyVim
-- Keymap("n", "<leader>lzu", "<CMD>Lazy update<CR>")

Keymap("n", "<leader>lzu", function()
	local lz = require("lazy")
	--- @type LazyPlugin[]
	local plugins = lz.plugins()
	local plg_to_update = {}
	for _, plg in ipairs(plugins) do
		if plg._.updates then
			-- print(plg.name)
			plg_to_update[#plg_to_update + 1] = plg
		end
	end
	lz.update({
		plugins = plg_to_update,
	})
end)
