local builtin = require("telescope.builtin")
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
	callback = function(event)
		local bufopts = { buffer = event.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
		vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
		vim.keymap.set({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, bufopts)
		vim.keymap.set("n", "<space>D", builtin.lsp_type_definitions, bufopts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("n", "<space>ds", builtin.lsp_document_symbols, bufopts)
		vim.keymap.set("n", "<space>ws", builtin.lsp_dynamic_workspace_symbols, bufopts)
		vim.keymap.set("n", "gr", function()
			builtin.lsp_references({ show_line = false })
		end, bufopts)
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)
