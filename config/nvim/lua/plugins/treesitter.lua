return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
	main = "nvim-treesitter.configs", -- sets main module to use for opts
	ensure_installed = {
		"lua",
		"typescript",
		"gitcommit",
		"vimdoc",
	},
	opts = {
		highlight = {
			enable = true,
		},
		indent = {
			enable = true,
		},
		auto_install = true,
	},
}
