return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- "master" está congelada/arquivada
		lazy = false,
		build = ":TSUpdate",
		dependencies = {
			"OXY2DEV/markview.nvim",
		},
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			local ensure_installed = {
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
			}

			-- instala só o que falta (equivalente ao antigo ensure_installed)
			local ok_cfg, cfg = pcall(require, "nvim-treesitter.config")
			local installed = (ok_cfg and cfg.get_installed) and cfg.get_installed() or {}
			local to_install = vim.iter(ensure_installed)
				:filter(function(p)
					return not vim.tbl_contains(installed, p)
				end)
				:totable()
			if #to_install > 0 then
				require("nvim-treesitter").install(to_install)
			end

			local disable_list = { "pascal", "help", "lua" }
			local max_filesize = 500 * 1024 -- 500 KB

			local function is_disabled(buf, lang)
				if vim.tbl_contains(disable_list, lang) then
					return true
				end
				local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					vim.notify("TS desabilitado por tamanho.")
					return true
				end
				return false
			end

			-- highlight (equivalente ao antigo highlight.enable + disable())
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts-highlight", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
					if is_disabled(ev.buf, lang) then
						return
					end
					if pcall(vim.treesitter.start, ev.buf, lang) then
						vim.bo[ev.buf].syntax = "" -- desliga highlight legado do vim
					end
				end,
			})

			-- indent (equivalente ao antigo indent.enable = true)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("ts-indent", { clear = true }),
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
					if not is_disabled(ev.buf, lang) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	-- autotag: plugin separado, sempre teve setup próprio (era cosmético no opts antigo)
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "tsx", "jsx" },
		opts = {},
	},

	-- incremental selection (<C-j>/<C-k>): removido do core do nvim-treesitter,
	-- restaurado via plugin dedicado (substitui o shushtain deprecado)
	{
		"daliusd/incr.nvim",
		event = "VeryLazy",
		opts = {
			incr_key = "<C-j>", -- expande seleção por nó
			decr_key = "<C-k>", -- encolhe seleção por nó
		},
	},
}
