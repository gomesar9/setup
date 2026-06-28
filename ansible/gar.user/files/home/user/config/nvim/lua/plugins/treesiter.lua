return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
		"OXY2DEV/markview.nvim",
	},
	opts = {
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
		sync_install = false,
		auto_install = true,
		ignore_install = { "pascal" },
		highlight = {
			enable = true,
			disable = function(lang, buf)
				local disable_list = { "pascal", "help", "lua" }
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
		-- rainbow e context_commentstring removidos: plugins separados,
		-- não são mais configurados via nvim-treesitter
	},
}
