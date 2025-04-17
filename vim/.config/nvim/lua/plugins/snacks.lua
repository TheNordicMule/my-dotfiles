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
			layout = {
				reverse = true,
				layout = {
					box = "horizontal",
					backdrop = false,
					width = 0.8,
					height = 0.9,
					border = "none",
					{
						box = "vertical",
						{ win = "list", title = " Results ", title_pos = "center", border = "rounded" },
						{
							win = "input",
							height = 1,
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
						},
					},
					{
						win = "preview",
						title = "{preview:Preview}",
						width = 0.45,
						border = "rounded",
						title_pos = "center",
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
			"<Leader>ts",
			function()
				require("snacks").picker.grep({
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
