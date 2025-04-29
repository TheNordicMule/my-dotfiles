return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "j-hui/fidget.nvim", opts = {} },
		{ "williamboman/mason.nvim" },
		{ "williamboman/mason-lspconfig.nvim" },
		{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		"saghen/blink.cmp",
	},
	event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- lazyload on file open
	config = function()
		-- Use an on_attach function to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
			callback = function(event)
				local bufopts = { buffer = event.buf }
				local snacks = require("snacks")

				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration", unpack(bufopts) })
				vim.keymap.set("n", "gd", function()
					snacks.picker.lsp_definitions()
				end, { desc = "Go to Definition", unpack(bufopts) })

				vim.keymap.set("n", "gi", function()
					snacks.picker.lsp_implementations()
				end, { desc = "Go to Implementation", unpack(bufopts) })

				vim.keymap.set("n", "gr", function()
					snacks.picker.lsp_references()
				end, { desc = "Find References", unpack(bufopts) })

				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({ border = "rounded" })
				end, { desc = "Hover Documentation", unpack(bufopts) })

				vim.keymap.set({ "i", "n" }, "<C-k>", function()
					vim.lsp.buf.signature_help({ border = "rounded" })
				end, { desc = "Signature Help", unpack(bufopts) })

				vim.keymap.set(
					"n",
					"<space>wa",
					vim.lsp.buf.add_workspace_folder,
					{ desc = "Add Workspace Folder", unpack(bufopts) }
				)
				vim.keymap.set(
					"n",
					"<space>wr",
					vim.lsp.buf.remove_workspace_folder,
					{ desc = "Remove Workspace Folder", unpack(bufopts) }
				)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, { desc = "List Workspace Folders", unpack(bufopts) })

				vim.keymap.set("n", "<space>D", function()
					snacks.picker.lsp_type_definitions()
				end, { desc = "Go to Type Definition", unpack(bufopts) })

				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, { desc = "Rename Symbol", unpack(bufopts) })
				vim.keymap.set(
					{ "n", "v" },
					"<space>ca",
					vim.lsp.buf.code_action,
					{ desc = "Code Action", unpack(bufopts) }
				)

				vim.keymap.set("n", "<space>ds", function()
					snacks.picker.lsp_symbols()
				end, { desc = "Document Symbols", unpack(bufopts) })

				vim.keymap.set("n", "<space>ws", function()
					snacks.picker.lsp_workspace_symbols()
				end, { desc = "Workspace Symbols", unpack(bufopts) })
			end,
		})

		local icons = require("icons")

		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
					[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
					[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
					[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				},
			},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
		})

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("mason").setup({
			PATH = "append",
		})

		local ensure_installed = { "pyright", "clangd", "gopls", "rust_analyzer", "nil", "ocamllsp", "lua_ls" }

		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"js-debug-adapter",
			"eslint_d",
			"prettierd",
		})

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
			automatic_installation = false,
			handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
			},
		})

		-- Mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		local opts = { noremap = true, silent = true }

		vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, { desc = "Show Diagnostics (Float)", unpack(opts) })

		vim.keymap.set(
			"n",
			"<space>q",
			vim.diagnostic.setloclist,
			{ desc = "Diagnostics to Location List", unpack(opts) }
		)
	end,
}
