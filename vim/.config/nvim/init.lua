vim.g.mapleader = " "

require("config.lazy")
require("config.options")
require("config.keymaps")
require("utils")

vim.cmd([[
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow\ --multiline-dotall
]])

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
