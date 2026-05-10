vim.lsp.set_log_level("warn") -- change to "debug" for more info

local capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	-- cmp_lsp.default_capabilities()
	require("blink.cmp").get_lsp_capabilities()
)

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		-- Unset 'formatexpr'
		-- vim.bo[args.buf].formatexpr = nil
		-- Unset 'omnifunc'
		-- vim.bo[args.buf].omnifunc = nil
		-- Unmap K
		-- vim.keymap.del("n", "K", { buffer = args.buf })
		local nmap = function(mode, key, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end
			Keymap(mode, key, func, { buffer = args.buf, desc = desc })
		end

		-- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
		-- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
		-- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
		-- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
		-- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
		-- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|

		-- Telescope with LSP
		-- Overrides
		nmap("n", "grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		nmap("n", "gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		nmap("n", "grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		nmap("n", "grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype [D]efinition")
		nmap("n", "<leader>s", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	-- update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		--source = "always",
		header = "",
		prefix = "",
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/implementation") then
			-- Create a keymap for vim.lsp.buf.implementation ...
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})
