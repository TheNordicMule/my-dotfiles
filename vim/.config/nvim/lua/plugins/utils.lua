return {
	-- looks
	{
		"mbbill/undotree",
		keys = {
			-- undo tree
			{ "<leader>u", "<cmd>UndotreeToggle<CR>" },
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
			{ "<leader>v", "<Plug>MarkdownPreviewToggle" },
		},
	},
}
