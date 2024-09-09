function Keymap(mode, lhs, rhs, opts)
	if opts == nil then
		opts = {
			silent = true,
		}
	end

	-- Set keya=maps using custom function Keymap
	vim.keymap.set(mode, lhs, rhs, opts)
end
