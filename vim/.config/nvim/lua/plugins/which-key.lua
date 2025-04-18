return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		delay = 1000,
		spec = {
			{ "<leader>c", group = "Code" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Hunks" },
			{ "<leader>n", group = "Neotest" },
			{ "<leader>t", group = "Search/telescope" },
			{ "<leader>w", group = "Workspace" },
			{ "[", group = "Prev" },
			{ "]", group = "Next" },
			{ "g", group = "Goto" },
			{ "z", group = "Fold" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show()
			end,
			desc = "Show which key",
		},
	},
}
