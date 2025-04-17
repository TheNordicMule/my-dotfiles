return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				theme = "nord",
			},
		},
	},
	{
		"gbprod/nord.nvim",
		priority = 1000,
		config = function()
			require("nord").setup({
				transparent = true,
			})
			vim.cmd.colorscheme("nord")
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
}
