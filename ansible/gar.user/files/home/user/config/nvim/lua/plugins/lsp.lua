return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"saghen/blink.cmp",
		"rafamadriz/friendly-snippets",
	},

	opts = {
		servers = {
			biome = {
				-- Tenta muito achar o root do js file
				root_dir = function(fname)
					local util = require("lspconfig.util")
					return util.root_pattern("biome.json", "biome.jsonc")(fname)
						or util.find_package_json_ancestor(fname)
						or util.find_node_modules_ancestor(fname)
						or util.find_git_ancestor(fname)
				end,
			},
		},
	},

	config = function()
		-- local cmp = require("cmp")
		-- local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			-- cmp_lsp.default_capabilities()
			require("blink.cmp").get_lsp_capabilities()
		)
		local default_lsp = require("plugins.lsp.config")
		-- require("luasnip.loaders.from_vscode").lazy_load()

		-- require("fidget").setup({})
		-- require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ansiblels",
				"eslint",
				-- "gopls",
				"lua_ls",
				-- "rust_analyzer",
				-- "biome",
			},
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = default_lsp.on_attach,
					})
				end,

				zls = function()
					local lspconfig = require("lspconfig")
					lspconfig.zls.setup({
						root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
						settings = {
							zls = {
								enable_inlay_hints = true,
								enable_snippets = true,
								warn_style = true,
							},
						},
					})
					vim.g.zig_fmt_parse_errors = 0
					vim.g.zig_fmt_autosave = 0
				end,
				["ansiblels"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.ansiblels.setup({
						capabilities = capabilities,
						on_attach = default_lsp.on_attach,
					})
				end,
				["lua_ls"] = function()
					local lspconfig = require("lspconfig")
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = default_lsp.on_attach,
						on_init = function(client)
							if client.workspace_folders then
								local path = client.workspace_folders[1].name
								if
									vim.loop.fs_stat(path .. "/.luarc.json")
									or vim.loop.fs_stat(path .. "/.luarc.jsonc")
								then
									return
								end
							end

							client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
								runtime = {
									-- Tell the language server which version of Lua you're using
									-- (most likely LuaJIT in the case of Neovim)
									version = "LuaJIT",
								},
								-- Make the server aware of Neovim runtime files
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
										-- Depending on the usage, you might want to add additional paths here.
										-- "${3rd}/luv/library"
										-- "${3rd}/busted/library",
									},
									-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
									-- library = vim.api.nvim_get_runtime_file("", true)
								},
							})
						end,
						settings = {
							Lua = {
								runtime = { version = "Lua 5.4.4" },
								diagnostics = {
									globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
								},
							},
						},
					})
				end,
			},
		})

		--local cmp_select = { behavior = cmp.SelectBehavior.Select }

		-- cmp.setup({
		-- 	snippet = {
		-- 		expand = function(args)
		-- 			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		-- 		end,
		-- 	},
		-- 	window = {
		-- 		completion = cmp.config.window.bordered(),
		-- 		documentation = cmp.config.window.bordered(),
		-- 	},
		-- 	mapping = cmp.mapping.preset.insert({
		-- 		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		-- 		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		-- 		["<CR>"] = cmp.mapping.confirm({ select = true }),
		-- 		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		-- 		["<C-d>"] = cmp.mapping.scroll_docs(4),
		-- 		["<C-Space>"] = cmp.mapping.complete(),
		-- 		["<C-e>"] = cmp.mapping.abort(),
		-- 	}),
		-- 	sources = cmp.config.sources({
		-- 		{ name = "nvim_lsp" },
		-- 		{ name = "luasnip" }, -- For luasnip users.
		-- 	}, {
		-- 		{ name = "buffer" },
		-- 	}),
		-- })

		vim.diagnostic.config({
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
	end,
}
