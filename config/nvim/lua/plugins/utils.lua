return {
	-- looks
	{
		"mbbill/undotree",
		keys = {
			-- undo tree
			{ "<leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
		},
	},

	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{ "<leader>v", "<Plug>MarkdownPreviewToggle", desc = "Markdown toggle" },
		},
	},
}
