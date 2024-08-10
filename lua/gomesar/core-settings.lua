vim.g.mapleader = " " -- Sets leader key

-- Basic setings
local options = {
	-- Tab and indentation
	autoindent = true, --Copy indent from current line when pressing â†µ
	expandtab = true, --Convert all tabs typed into spaces
	shiftround = true, --Always indent/outdent to the nearest tabstop
	shiftwidth = 4, --Indent/outdent by four colums
	tabstop = 4, --An indentation level for every four columns

	-- Visual
	--background = "dark", --Adjusts the default color groups for that background type
	--colorcolumn = "80", --Highlights the Nth column
	conceallevel = 0, --Text is shown normally
	cursorcolumn = false, --Highlight the screen column of the cursor
	cursorline = true, --Highlight the screen line   of the cursor
	--foldmethod     = 'indent', --Folding used for the current window.
	hlsearch = false, --Don't highlight all incidences of a search pattern
	laststatus = 3, --Whether the last window will have a status line
	lazyredraw = true, --Don't redraw screen when executing macros
	number = true, --Shows line number
	relativenumber = true, --Shows relative instead of absolute numbers
	ruler = false, --Don't show the line and column number of the cursor position
	showcmd = false, --Don't show (partial) command in the last line of the screen.
	showmode = false, --Don't show Insert/Replace/Visual modes in the the last line.
	--signcolumn = "no", --Always show sign column
	splitbelow = true, --New horizontal windows open at the bottom
	splitright = true, --New vertical   windows open at the right
	termguicolors = true, --Enables 24-bit RGB color in the TUI.
	title = true, --Set title of window as the title of document (if not empty)
	wrap = false, --Don't wrap long lines

    -- Primegean
    scrolloff = 8, -- Never reach the end of file
    signcolumn = "yes",  -- Dont know

	-- Others
	--undodir      = '~/.cache/nvim/undodir',   --Defines the undo directory
	clipboard = "unnamedplus", --Always use clipboard for all operations instead of '+/*'
	completeopt = { "menuone", "noselect" }, --Insert-mode completion options
	encoding = "utf-8", --String  encoding used internally.
	mouse = "", --No mouse usage :D
	smartcase = true, --Override the 'ignorecase' option if the search pattern contains upper case characters.
	smartindent = true, --Do smart autoindenting when starting a new line
	timeoutlen = 500, --Time (ms) to wait for a mapped sequenge to complete
	undofile = true, --Allow undo file after :wq-ing
	updatetime = 100, --Faster completion
	wildmode = "longest,list,full", --Enable autocompletion
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.opt.formatoptions = vim.opt.formatoptions - "c" - "r" - "o" -- Disables automatic commenting on newline

-- Exit to main with LEADER P V
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Open nvim config
vim.keymap.set("", "<leader>ne", ":vsp ~/.config/nvim")

-- Compile neorg
--vim.api.nvim_buf_set_keymap(bufnr , "n" , "<leader>nc" , "<cmd>Neorg tangle current-file<CR>", opts)
vim.keymap.set("n", "<leader>nc" , ":Neorg tangle current-file<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "Y", "yg$")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste like a God
vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function ()
    vim.lsp.buf.format()
end)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--local colorscheme = "solarized-high"
--local colorscheme = "tokyonight"
--vim.g.tokyonight_style = "night"

--local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

--if not status_ok then
--	vim.notify("Colorscheme " .. colorscheme .. " not found.")
--	return
--end

--[[
vim.cmd [[
    " Turns off highlighting on the bits of code that are changed, so the line
    " that is changed is highlighted but the actual text that has changed
    " stands out on the line and is readable.
    if &diff
        highlight! link DiffText MatchParen
    endif
]]
--]]
