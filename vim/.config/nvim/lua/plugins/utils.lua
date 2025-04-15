return {
	-- looks
	"mbbill/undotree",

	-- install without yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	install = { colorscheme = { "nord" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
}
