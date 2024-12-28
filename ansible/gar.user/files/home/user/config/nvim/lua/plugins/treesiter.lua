return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	-- event = "VeryLazy",
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = {
				"bash",
				"c",
				"css",
				"dockerfile",
				"gitignore",
				"html",
				"java",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"go",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (or "all")
			ignore_install = { "pascal", "help" },

			highlight = {
				enable = true,
				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				-- disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local disable_list = { "pascal", "help" }
					local max_filesize = 500 * 1024 -- 500 KB

					for _, v in ipairs(disable_list) do
						if v == lang then
							return true
						end
					end

					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						vim.notify("TS desabilitado por tamanho.")
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-j>",
					node_incremental = "<C-j>",
					scope_incremental = false,
					node_decremental = "<C-k>",
				},
			},

			indent = { enable = true },

			autotag = {
				enable = true,
			},

			rainbow = {
				enable = true,
				disable = { "html" },
				extended_mode = false,
				max_file_lines = nil,
			},

			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
		})
	end,
}
