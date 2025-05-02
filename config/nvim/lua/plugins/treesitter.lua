return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile", "BufWritePre", "VeryLazy" },
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
  main = "nvim-treesitter.configs", -- sets main module to use for opts
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
