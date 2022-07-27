local opts = {noremap = true}

vim.api.nvim_set_keymap('n', "<Leader>dd", "<cmd>:lua require('dapui').open()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>de", "<cmd>:lua require('dapui').close()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dc", "<cmd>:lua require('dap').continue()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dt", "<cmd>:lua require('dap').toggle_breakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dT", "<cmd>:lua require'dap'.clear_breakpoints()<CR>", opts)

vim.api.nvim_set_keymap('n', "<Leader>dk", "<cmd>:lua require('dap').reverse_continue()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dh", "<cmd>:lua require('dap').step_out()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dl", "<cmd>:lua require('dap').step_into()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dj", "<cmd>:lua require('dap').step_over()<CR>", opts)

require("dapui").setup()
require("nvim-dap-virtual-text").setup()
vim.api.nvim_set_keymap('n', "<leader>m", "<cmd>:MaximizerToggle!<CR>", opts)
