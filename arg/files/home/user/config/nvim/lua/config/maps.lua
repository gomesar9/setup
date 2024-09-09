vim.g.mapleader = " "

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
