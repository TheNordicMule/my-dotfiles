return {
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- lazyload on file open
		opts = {},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			{ "mason-org/mason.nvim" },
			{ "mason-org/mason-lspconfig.nvim" },
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
					end, { desc = "Find References", unpack(bufopts), nowait = true })

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

					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						vim.keymap.set({ "n", "i" }, "<leader>uh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, { desc = "[U]I: Inlay [H]ints", unpack(bufopts) })
					end
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

			local ensure_installed =
				{ "pyright", "clangd", "gopls", "rust_analyzer", "nil", { "ocamllsp", version = "1.19.0" }, "lua_ls" }

			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"js-debug-adapter",
				"eslint_d",
				"prettierd",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed, run_on_start = true })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				automatic_enable = true,
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

			vim.keymap.set(
				"n",
				"<space>e",
				vim.diagnostic.open_float,
				{ desc = "Show Diagnostics (Float)", unpack(opts) }
			)
		end,
	},
}
