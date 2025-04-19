return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
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
