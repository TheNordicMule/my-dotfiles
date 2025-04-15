return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		vim.keymap.set({ "n", "v" }, "<Leader>ff", function()
			conform.format({
				lsp_fallback = true,
			})
		end, {})

		conform.setup({
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
