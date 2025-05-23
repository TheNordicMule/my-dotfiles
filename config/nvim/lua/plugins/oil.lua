return {
	"stevearc/oil.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", opts = {} },
	},
	opts = {
		default_file_explorer = false,
		keymaps = {
			["<C-v>"] = "actions.select_vsplit",
			["<C-s>"] = "actions.select_split",
			["<C-p>"] = false,
		},
		view_options = {
			show_hidden = true,
		},
	},
	keys = {
		{ "<leader>fe", "<cmd>Oil<CR>", desc = "File Explorer" },
	},
}
