return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	build = ":TSUpdate",
	lazy = false,
	keys = {
		{ "<leader>ui", "<cmd>Inspect<CR>", desc = "Inspect Node" },
		{ "<leader>uI", "<cmd>InspectTree<CR>", desc = "Inspect Tree" },
	},
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true }),
			callback = function(ev)
				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
}
