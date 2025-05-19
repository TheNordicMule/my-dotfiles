return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
	main = "nvim-treesitter.configs", -- sets main module to use for opts
	keys = {
		{ "<leader>ui", "<cmd>Inspect<CR>", desc = "Inspect Node" },
		{ "<leader>uI", "<cmd>InspectTree<CR>", desc = "Inspect Tree" },
	},
	opts = {
		ensure_installed = {
			"lua",
			"typescript",
			"gitcommit",
			"vimdoc",
			"regex",
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		auto_install = true,
	},
}
