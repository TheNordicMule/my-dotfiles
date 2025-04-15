return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		{ "<Leader>dd", "<cmd>:lua ToggleDap()<CR>" },
		{ "<Leader>de", "<cmd>:lua require('dap').terminate()<CR>" },
		{
			"<Leader>dc",
			function()
				require("dap").continue()
			end,
		},
		{ "<Leader>dC", "<cmd>:lua require('dap').set_breakpoint(vim.fn.input('Conditional Breakpoint > '))<CR>" },
		{ "<Leader>dt", "<cmd>:lua require('dap').toggle_breakpoint()<CR>" },
		{ "<Leader>dT", "<cmd>:lua require'dap'.clear_breakpoints()<CR>" },
		{ "<Leader>dr", "<cmd>:lua require'dap'.run_to_cursor()<CR>" },

		-- new addition to experiment
		{ "<Leader>dn", "<cmd>:lua require('dap').run_last()<CR>" },
		{
			"<Leader>dp",
			function()
				require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
		},
		{ "<Leader>df", "<cmd>:lua require('dapui').float_element()<CR>" },
		{ "<Leader>dk", "<cmd>:lua require('dapui').eval()<CR>" },
		{ "<Leader>dh", "<cmd>:lua require('dap').step_out()<CR>" },
		{ "<Leader>dl", "<cmd>:lua require('dap').step_into()<CR>" },
		{ "<Leader>dj", "<cmd>:lua require('dap').step_over()<CR>" },
		{ "<Leader>dx", "<cmd>:lua require('dap').set_exception_breakpoints()<CR>" },
	},
	config = function()
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
	end,
}
