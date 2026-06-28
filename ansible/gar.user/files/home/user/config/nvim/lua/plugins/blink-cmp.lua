return {
	"saghen/blink.cmp",
	version = "1.*", -- Use version 1.x to avoid v2 requirements
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"hrsh7th/nvim-cmp",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},

	-- use a release tag to download pre-built binaries
	-- version = "v0.9.*",

	opts = {
		fuzzy = {
			implementation = "lua",
		},

		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		keymap = {
			--preset = "default",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
			["<CR>"] = { "accept", "fallback" },

			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },

			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },

			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- Breakchange da versao 0.10.0
		-- snippets = {
		-- 	preset = "luasnip",
		-- },

		-- default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, via `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			-- optionally disable cmdline completions
			--
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					-- make lazydev completions top priority (see `:h blink.cmp`)
					score_offset = 100,
				},
			},
			-- cmdline = {},
			min_keyword_length = function(ctx)
				if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
					return 2
				end
				return 0
			end,
		},

		-- experimental signature help support
		signature = { enabled = true },

		-- Completion
		completion = {
			menu = {
				auto_show = true,
			},
			documentation = {
				-- Controls whether the documentation window will automatically show when selecting a completion item
				auto_show = true,
				-- Delay before showing the documentation window
				auto_show_delay_ms = 400,
				-- Delay before updating the documentation window when selecting a new item,
				-- while an existing item is still visible
				update_delay_ms = 100,
				-- Whether to use treesitter highlighting, disable if you run into performance issues
				treesitter_highlighting = true,
				window = {
					min_width = 10,
					max_width = 80,
					max_height = 20,
					border = "padded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					-- Note that the gutter will be disabled when border ~= 'none'
					scrollbar = true,
					-- Which directions to show the documentation window,
					-- for each of the possible menu window directions,
					-- falling back to the next direction when there's not enough space
					direction_priority = {
						menu_north = { "e", "w", "n", "s" },
						menu_south = { "e", "w", "s", "n" },
					},
				},
			},
			list = {
				-- selection = "auto_insert",
				-- Breakchange da versao 0.10.0
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},
		},
	},
	-- allows extending the providers array elsewhere in your config
	-- without having to redefine it
	opts_extend = { "sources.default" },
}
