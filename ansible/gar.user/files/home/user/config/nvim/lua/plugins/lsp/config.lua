local M = {}

vim.lsp.set_log_level("warn") -- change to "debug" for more info

M.on_attach = function(_, bufnr)
	local nmap = function(mode, key, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		Keymap(mode, key, func, { buffer = bufnr, desc = desc })
	end

	-- Telescope with LSP
	nmap("n", "gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
	nmap("n", "gtd", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype [D]efinition")
	nmap("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("n", "gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
	nmap("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

	-- Common
	nmap("n", "<leader>r", vim.lsp.buf.rename, "[R]ename")
end
return M
