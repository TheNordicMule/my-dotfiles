return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<Leader>ff",
			function()
				require("conform").format({
					lsp_fallback = true,
				})
			end,
			mode = { "n", "v" },
			desc = "Format file or selection",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				markdown = { "prettierd" },
				lua = { "stylua" },
				nix = { "alejandra" },
				ocaml = { "ocamlformat" },
			},
		})
	end,
}
