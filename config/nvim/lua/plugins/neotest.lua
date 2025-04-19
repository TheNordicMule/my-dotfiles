return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"alfaix/neotest-gtest",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-jest",
	},
	keys = {
		-- Run tests for the current file
		{
			"<leader>nt",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "Run Tests for Current File",
		},

		-- Run tests for the current working directory
		{
			"<leader>nT",
			function()
				require("neotest").run.run(vim.loop.cwd())
			end,
			desc = "Run Tests for Current Directory",
		},

		-- Run all tests
		{
			"<leader>nn",
			function()
				require("neotest").run.run()
			end,
			desc = "Run All Tests",
		},

		-- Run tests using DAP strategy
		{
			"<leader>nd",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "Run Tests with DAP",
		},

		-- Toggle the summary of test results
		{
			"<leader>ns",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle Test Summary",
		},

		-- Open the output of the last test run
		{
			"<leader>no",
			function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end,
			desc = "Open Test Output",
		},

		-- Toggle the output panel for tests
		{
			"<leader>nO",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle Test Output Panel",
		},

		-- Stop running tests
		{
			"<leader>nS",
			function()
				require("neotest").run.stop()
			end,
			desc = "Stop Running Tests",
		},
	},
	config = function()
		local opts = {}
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					-- Replace newline and tab characters with space for more compact diagnostics
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		opts.consumers = opts.consumers or {}

		if opts.adapters then
			local adapters = {}
			for name, config in pairs(opts.adapters or {}) do
				if type(name) == "number" then
					if type(config) == "string" then
						config = require(config)
					end
					adapters[#adapters + 1] = config
				elseif config ~= false then
					local adapter = require(name)
					if type(config) == "table" and not vim.tbl_isempty(config) then
						local meta = getmetatable(adapter)
						if adapter.setup then
							adapter.setup(config)
						elseif meta and meta.__call then
							adapter(config)
						else
							error("Adapter " .. name .. " does not support setup")
						end
					end
					adapters[#adapters + 1] = adapter
				end
			end
			opts.adapters = adapters
		end

		local neotest = require("neotest")

		neotest.setup({
			adapters = {
				require("neotest-vitest"),
				require("neotest-jest"),
			},
			status = { virtual_text = true },
			output = { open_on_run = true },
		})
	end,
}
