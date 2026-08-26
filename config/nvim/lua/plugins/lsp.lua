return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
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

					vim.keymap.set("n", "gai", function()
						snacks.picker.lsp_incoming_calls()
					end, { desc = "C[a]lls Incoming", unpack(bufopts) })

					vim.keymap.set("n", "gao", function()
						snacks.picker.lsp_outgoing_calls()
					end, { desc = "C[a]lls Outgoing", unpack(bufopts) })

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

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
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

			local servers = {
				lua_ls = {
					-- cmd = { ... },
					-- filetypes = { ... },
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
				-- All language servers are installed by Nix/Home Manager (see
				-- modules/features/nvim.nix); empty maps just get enabled.
				pyright = {},
				clangd = {},
				gopls = {},
				rust_analyzer = {},
				nixd = {}, -- lspconfig id differs from the Nix package name (`nil`)
				ocamllsp = {},
				vtsls = {},
				jsonls = {},
			}

			-- Configure nonempty entries; empty maps use the lspconfig defaults.
			for server, config in pairs(servers) do
				if not vim.tbl_isempty(config) then
					vim.lsp.config(server, config)
				end
			end

			local ts_inlay_hints = {
				inlayHints = {
					parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
					parameterTypes = { enabled = true },
					variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
					propertyDeclarationTypes = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					enumMemberValues = { enabled = true },
				},
			}
			vim.lsp.config("vtsls", {
				settings = {
					typescript = ts_inlay_hints,
					javascript = ts_inlay_hints,
				},
			})

			-- Enable every server directly; all are installed by Nix/Home Manager
			-- (see modules/features/nvim.nix).
			vim.lsp.enable(vim.tbl_keys(servers))
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
