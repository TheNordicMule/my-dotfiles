return { -- Autocompletion
	"saghen/blink.cmp",
	event = "InsertEnter",
	version = "1.*",
	dependencies = {
		{
			"saghen/blink.compat",
			-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
			version = "*",
			-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
			lazy = true,
			-- make sure to set opts so that lazy.nvim calls blink.compat's setup
			opts = {},
		},
		"rcarriga/cmp-dap",
		{ "nvim-tree/nvim-web-devicons", opts = {} },
		-- Snippet Engine
		{
			"L3MON4D3/LuaSnip",
			version = "2.*",
			build = "make install_jsregexp",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {},
		},
		{
			-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
			-- used for completion, annotations and signatures of Neovim apis
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		"onsails/lspkind.nvim",
	},
	opts = {
		keymap = {
			preset = "enter",
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
		},
		appearance = {
			nerd_font_variant = "normal",
		},

		completion = {
			-- By default, you may press `<c-space>` to show the documentation.
			-- Optionally, set `auto_show = true` to show the documentation after a delay.
			documentation = { auto_show = true, auto_show_delay_ms = 500 },

			menu = {
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbolic(ctx.kind, {
										mode = "symbol",
									})
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
					columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
				min_width = 30,
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "lazydev", "buffer" },
			per_filetype = {
				["dap-repl"] = { "dap" },
				["dapui_watches"] = { "dap" },
				["dapui_hover"] = { "dap" },
			},
			providers = {
				dap = { name = "dap", module = "blink.compat.source" },
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},

		snippets = { preset = "luasnip" },

		fuzzy = { implementation = "prefer_rust_with_warning" },

		signature = { enabled = true },
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		-- Autocommand for DAP filetypes
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "dap-repl", "dapui_watches", "dapui_hover" },
			callback = function()
				vim.b.completion = true
			end,
			desc = "Enable completion for DAP-REPL filetypes",
		})
	end,
}
