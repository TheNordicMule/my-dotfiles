return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
	keys = {
		{ "<leader>ui", "<cmd>Inspect<CR>", desc = "Inspect Node" },
		{ "<leader>uI", "<cmd>InspectTree<CR>", desc = "Inspect Tree" },
	},
	config = function()
		-- Enable treesitter highlighting (injections work automatically)
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
				if not pcall(vim.treesitter.language.inspect, lang) then
					local ok, parsers = pcall(require("nvim-treesitter").get_available)
					if not ok or not vim.tbl_contains(parsers, lang) then
						return
					end
					pcall(function()
						require("nvim-treesitter").install(lang)
					end)
				end
				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
}
