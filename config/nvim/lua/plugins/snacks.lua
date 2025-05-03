return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = false },
		indent = { enabled = false },
		input = { enabled = true },
		picker = {
			enabled = true,
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
			desc = "Pick files",
		},

		{
			"<Leader>tp",
			function()
				require("snacks").picker.files({
					hidden = true,
				})
			end,
			desc = "All files(hidden)",
		},
		{
			"<Leader>tf",
			function()
				require("snacks").picker.pickers()
			end,
			desc = "Pickers",
		},

		{
			"<Leader>ts",
			function()
				require("snacks").picker.grep({
					live = false,
					search = vim.fn.input("Grep For > "),
				})
			end,
			desc = "Pick string",
		},

		{
			"<Leader>tw",
			function()
				require("snacks").picker.grep_word()
			end,
			desc = "Pick current word",
		},

		{
			"<Leader>tb",
			function()
				require("snacks").picker.buffers()
			end,
			desc = "Pick buffers",
		},
		{
			"<Leader>tq",
			function()
				require("snacks").picker.qflist()
			end,
			desc = "Pick quickfix",
		},
		{
			"<Leader>tr",
			function()
				require("snacks").picker.registers()
			end,
			desc = "Pick registers",
		},
		{
			"<Leader>td",
			function()
				require("snacks").picker.diagnostics()
			end,
			desc = "Pick diagnostics",
		},
		{
			"<Leader>th",
			function()
				require("snacks").picker.help()
			end,
			desc = "Pick help",
		},
		{
			"<Leader>tc",
			function()
				require("snacks").picker.commands()
			end,
			desc = "Pick commands",
		},
		{
			"<Leader>tg",
			function()
				require("snacks").picker.git_branches({
					all = true,
				})
			end,
			desc = "Pick git branches",
		},
		{
			"<leader>gh",
			function()
				require("snacks").gitbrowse()
			end,
			desc = "Browse git",
		},
	},
}
