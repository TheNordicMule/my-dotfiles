local opts = { noremap = true }
local dap, dapui = require("dap"), require("dapui")
require("nvim-dap-virtual-text").setup()

require("dapui").setup({
  layouts = {
    { elements = { "console" }, size = 7, position = "bottom" }, {
    elements = {
      -- Elements can be strings or table with id and size keys.
      { id = "scopes", size = 0.25 }, "watches"
    },
    size = 40,
    position = "left"
  }
  }
})

function ToggleDap()
  dapui.toggle({ reset = true })
end

dap.listeners.after.event_initialized["dapui_config"] =
    function() dapui.open(1) end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] =
    function() dapui.close({}) end

vim.api.nvim_set_keymap('n', "<Leader>dd",
  "<cmd>:lua ToggleDap()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>de",
  "<cmd>:lua require('dap').terminate()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dc",
  "<cmd>:lua require('dap').continue()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dt",
  "<cmd>:lua require('dap').toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dT",
  "<cmd>:lua require'dap'.clear_breakpoints()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dr",
  "<cmd>:lua require'dap'.run_to_cursor()<CR>", opts)

vim.api.nvim_set_keymap('n', "<Leader>df",
  "<cmd>:lua require('dapui').float_element()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dk",
  "<cmd>:lua require('dapui').eval()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dh",
  "<cmd>:lua require('dap').step_out()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dl",
  "<cmd>:lua require('dap').step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dj",
  "<cmd>:lua require('dap').step_over()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dx",
  "<cmd>:lua require('dap').set_exception_breakpoints()<CR>", opts)

vim.api.nvim_set_keymap('n', "<leader>m", "<cmd>:MaximizerToggle!<CR>", opts)

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/Users/mingshiwang/.local/share/nvim/mason/packages/codelldb/codelldb',
    args = { "--port", "${port}" },
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/test/lru_k_replacer_test')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
