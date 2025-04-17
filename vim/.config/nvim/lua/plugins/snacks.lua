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
		},

		{
			"<Leader>tp",
			function()
				require("snacks").picker.files({
					hidden = true,
				})
			end,
		},
		{
			"<Leader>tf",
			function()
				require("snacks").picker.pickers()
			end,
		},

		{
			"<Leader>ts",
			function()
				require("snacks").picker.grep({
					live = false,
					search = vim.fn.input("Grep For > "),
				})
			end,
		},

		{
			"<Leader>tw",
			function()
				require("snacks").picker.grep_word()
			end,
		},

		{
			"<Leader>tb",
			function()
				require("snacks").picker.buffers()
			end,
		},
		{
			"<Leader>tq",
			function()
				require("snacks").picker.qflist()
			end,
		},
		{
			"<Leader>tr",
			function()
				require("snacks").picker.registers()
			end,
		},
		{
			"<Leader>td",
			function()
				require("snacks").picker.diagnostics()
			end,
		},
		{
			"<Leader>th",
			function()
				require("snacks").picker.help()
			end,
		},
		{
			"<Leader>tc",
			function()
				require("snacks").picker.commands()
			end,
		},
		{
			"<Leader>tg",
			function()
				require("snacks").picker.git_branches()
			end,
		},
		{
			"<leader>gh",
			function()
				require("snacks").gitbrowse()
			end,
		},
	},
}
