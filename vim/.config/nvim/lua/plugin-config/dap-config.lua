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

local home = os.getenv('HOME')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {
    home ..
    '/.local/share/nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'
  }
}

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
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build/test/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal'
  }, {
  -- For this to work you need to make sure the node process is started with the `--inspect` flag.
  name = 'Attach to process',
  type = 'node2',
  request = 'attach',
  processId = require 'dap.utils'.pick_process
}
}

dap.configurations.typescript = {
  {
    name = "ts-node (Node2 with ts-node)",
    type = "node2",
    request = "launch",
    cwd = vim.loop.cwd(),
    runtimeArgs = { "-r", "ts-node/register" },
    runtimeExecutable = "node",
    args = { "--inspect", "${file}" },
    sourceMaps = true,
    skipFiles = { "<node_internals>/**", "node_modules/**" }
  }, {
  name = "Jest (Node2 with ts-node)",
  type = "node2",
  request = "launch",
  cwd = vim.loop.cwd(),
  runtimeArgs = {
    "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest"
  },
  runtimeExecutable = "node",
  args = { "${file}", "--runInBand", "--coverage", "false" },
  sourceMaps = true,
  port = 9229,
  skipFiles = { "<node_internals>/**", "node_modules/**" }
}
}
