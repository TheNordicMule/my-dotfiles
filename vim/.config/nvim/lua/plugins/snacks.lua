return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = true },
		picker = {
			enabled = true,
			win = {
				input = {
					keys = {
						["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
					},
				},
			},
		},
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = false },
	},
	keys = {
		{
			"<C-p>",
			function()
				require("snacks").picker.git_files()
			end,
			desc = "pick files",
		},

		{
			"<Leader>tp",
			function()
				require("snacks").picker.files({
					hidden = true,
				})
			end,
			desc = "all files(hidden)",
		},
		{
			"<Leader>tf",
			function()
				require("snacks").picker.pickers()
			end,
			desc = "pickers",
		},

		{
			"<Leader>ts",
			function()
				require("snacks").picker.grep({
					live = false,
					search = vim.fn.input("Grep For > "),
				})
			end,
			desc = "pick string",
		},

		{
			"<Leader>tw",
			function()
				require("snacks").picker.grep_word()
			end,
			desc = "pick current word",
		},

		{
			"<Leader>tb",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "pick buffers",
		},
		{
			"<Leader>tq",
			function()
				require("snacks").picker.qflist()
			end,
			desc = "pick quickfix",
		},
		{
			"<Leader>tr",
			function()
				require("snacks").picker.registers()
			end,
			desc = "pick registers",
		},
		{
			"<Leader>td",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "pick diagnostics",
		},
		{
			"<Leader>th",
			function()
				require("snacks").picker.help()
			end,
			desc = "pick help",
		},
		{
			"<Leader>tc",
			function()
				require("snacks").picker.commands()
			end,
			desc = "pick commands",
		},
		{
			"<Leader>tg",
			function()
				require("snacks").picker.git_branches({
					all = true,
				})
			end,
			desc = "pick git branches",
		},
		{
			"<leader>gh",
			function()
				require("snacks").gitbrowse()
			end,
			desc = "browse git",
		},
	},
}
