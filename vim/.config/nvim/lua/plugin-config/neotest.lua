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

vim.keymap.set("n", "<leader>nt", function()
	require("neotest").run.run(vim.fn.expand("%"))
end)
vim.keymap.set("n", "<leader>nT", function()
	require("neotest").run.run(vim.loop.cwd())
end)
vim.keymap.set("n", "<leader>nn", function()
	require("neotest").run.run()
end)
vim.keymap.set("n", "<leader>nd", function()
	require("neotest").run.run({ strategy = "dap" })
end)
vim.keymap.set("n", "<leader>ns", function()
	require("neotest").summary.toggle()
end)
vim.keymap.set("n", "<leader>no", function()
	require("neotest").output.open({ enter = true, auto_close = true })
end)
vim.keymap.set("n", "<leader>nO", function()
	require("neotest").output_panel.toggle()
end)
vim.keymap.set("n", "<leader>nS", function()
	require("neotest").run.stop()
end)

neotest.setup({
	adapters = {
		require("neotest-gtest").setup({}),
	},
	status = { virtual_text = true },
	output = { open_on_run = true },
})
