return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				globalstatus = true,
			},
		},
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				snacks = {
					enabled = true,
				},
				float = {
					transparent = true, -- enable transparent floating windows
				},
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"gbprod/nord.nvim",
		priority = 1000,
		enabled = false,
		config = function()
			require("nord").setup({})
			vim.cmd.colorscheme("nord")
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
}
