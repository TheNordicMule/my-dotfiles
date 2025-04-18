return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	keys = {
		-- 🐞 Debugging Controls
		{ "<Leader>dd", "<cmd>:lua ToggleDap()<CR>", desc = "Toggle custom DAP UI" },
		{ "<Leader>de", "<cmd>:lua require('dap').terminate()<CR>", desc = "Terminate debug session" },
		{
			"<Leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Start/Continue debugging",
		},
		{
			"<Leader>dC",
			"<cmd>:lua require('dap').set_breakpoint(vim.fn.input('Conditional Breakpoint > '))<CR>",
			desc = "Set conditional breakpoint",
		},
		{ "<Leader>dt", "<cmd>:lua require('dap').toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
		{ "<Leader>dT", "<cmd>:lua require'dap'.clear_breakpoints()<CR>", desc = "Clear all breakpoints" },
		{ "<Leader>dr", "<cmd>:lua require'dap'.run_to_cursor()<CR>", desc = "Run to cursor" },

		-- 🔁 Replay & Log Points
		{ "<Leader>dn", "<cmd>:lua require('dap').run_last()<CR>", desc = "Run last debug session" },
		{
			"<Leader>dp",
			function()
				require("dap").toggle_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "Set log point (with message)",
		},

		-- 🧩 DAP UI Interactions
		{ "<Leader>df", "<cmd>:lua require('dapui').float_element()<CR>", desc = "Open floating DAP UI" },
		{ "<Leader>dk", "<cmd>:lua require('dapui').eval()<CR>", desc = "Evaluate expression" },

		-- 🔍 Stepping Through Code
		{ "<Leader>dh", "<cmd>:lua require('dap').step_out()<CR>", desc = "Step out" },
		{ "<Leader>dl", "<cmd>:lua require('dap').step_into()<CR>", desc = "Step into" },
		{ "<Leader>dj", "<cmd>:lua require('dap').step_over()<CR>", desc = "Step over" },

		-- ⚠️ Exception Handling
		{
			"<Leader>dx",
			"<cmd>:lua require('dap').set_exception_breakpoints()<CR>",
			desc = "Set exception breakpoints",
		},
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

		require("dap").adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				-- 💀 Make sure to update this path to point to your installation
				args = {
					home .. "/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}

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
