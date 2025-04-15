-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	install = { colorscheme = { "nord" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
