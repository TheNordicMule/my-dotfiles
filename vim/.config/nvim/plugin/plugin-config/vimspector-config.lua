local opts = {noremap = true}

vim.api.nvim_set_keymap('n', "<Leader>dd", "<cmd>:call vimspector#Launch()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>de", "<cmd>:call vimspector#Reset()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dc", "<cmd>:call vimspector#Continue()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dt", "<cmd>:call vimspector#ToggleBreakpoint()<CR>", opts)
vim.api.nvim_set_keymap('n', "<Leader>dT", "<cmd>:call vimspector#ClearBreakpoints()<CR>", opts)

vim.api.nvim_set_keymap('n', "<Leader>dr", "<Plug>VimspectorRestart", {})
vim.api.nvim_set_keymap('n', "<Leader>dh", "<Plug>VimspectorStepOut", {})
vim.api.nvim_set_keymap('n', "<Leader>dl", "<Plug>VimspectorStepInto", {})
vim.api.nvim_set_keymap('n', "<Leader>dj", "<Plug>VimspectorStepOver", {})

vim.api.nvim_set_keymap('n', "<leader>m", "<cmd>:MaximizerToggle!<CR>", opts)
