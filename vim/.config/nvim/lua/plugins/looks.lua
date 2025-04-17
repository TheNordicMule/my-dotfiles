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
		"shaunsingh/nord.nvim",
		priority = 1000,
		config = function()
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
