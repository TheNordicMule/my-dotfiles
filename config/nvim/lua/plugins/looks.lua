return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			require("lualine").setup({
				options = {
					theme = "catppuccin",
					-- ... the rest of your lualine config
				},
			})
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
	{
		"nordtheme/vim",
		--   priority = 1000,
		-- config = function()
		-- 	vim.cmd.colorscheme("nord")
		--
		-- 	-- Remove background color from Normal and other UI groups
		-- 	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		-- 	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
		-- 	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- 	vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		-- 	vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
		-- end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
		},
	},
}
