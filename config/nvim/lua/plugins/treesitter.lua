return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	lazy = false,
	keys = {
		{ "<leader>ui", "<cmd>Inspect<CR>", desc = "Inspect Node" },
		{ "<leader>uI", "<cmd>InspectTree<CR>", desc = "Inspect Tree" },
	},
}
