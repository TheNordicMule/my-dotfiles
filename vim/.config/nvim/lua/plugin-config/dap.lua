local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()

require("dapui").setup({
	layouts = {
		{ elements = { "console", "repl" }, size = 7, position = "bottom" },
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"watches",
			},
			size = 40,
			position = "left",
		},
	},
})

function ToggleDap()
	dapui.toggle({ reset = true })
end

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close({})
end

vim.keymap.set("n", "<Leader>dd", "<cmd>:lua ToggleDap()<CR>")
vim.keymap.set("n", "<Leader>de", "<cmd>:lua require('dap').terminate()<CR>")
vim.keymap.set("n", "<Leader>dc", "<cmd>:lua require('dap').continue()<CR>")
vim.keymap.set(
	"n",
	"<Leader>dC",
	"<cmd>:lua require('dap').set_breakpoint(vim.fn.input('Conditional Breakpoint > '))<CR>"
)
vim.keymap.set("n", "<Leader>dt", "<cmd>:lua require('dap').toggle_breakpoint()<CR>")
vim.keymap.set("n", "<Leader>dT", "<cmd>:lua require'dap'.clear_breakpoints()<CR>")
vim.keymap.set("n", "<Leader>dr", "<cmd>:lua require'dap'.run_to_cursor()<CR>")

-- new addition to experiment
vim.keymap.set("n", "<Leader>dn", "<cmd>:lua require('dap').run_last()<CR>")
vim.keymap.set("n", "<Leader>dp", function()
	require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)

vim.keymap.set("n", "<Leader>df", "<cmd>:lua require('dapui').float_element()<CR>")
vim.keymap.set("n", "<Leader>dk", "<cmd>:lua require('dapui').eval()<CR>")
vim.keymap.set("n", "<Leader>dh", "<cmd>:lua require('dap').step_out()<CR>")
vim.keymap.set("n", "<Leader>dl", "<cmd>:lua require('dap').step_into()<CR>")
vim.keymap.set("n", "<Leader>dj", "<cmd>:lua require('dap').step_over()<CR>")
vim.keymap.set("n", "<Leader>dx", "<cmd>:lua require('dap').set_exception_breakpoints()<CR>")

vim.keymap.set("n", "<leader>m", "<cmd>:MaximizerToggle!<CR>")

vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo", linehl = nil, numhl = nil })
vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DapStopped", linehl = nil, numhl = nil })
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = " ", texthl = "DapBreakpointRejected", linehl = nil, numhl = nil }
)

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "/Users/mingshiwang/.local/share/nvim/mason/packages/codelldb/codelldb",
		args = { "--port", "${port}" },
	},
}
dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
