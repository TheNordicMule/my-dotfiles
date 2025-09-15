vim.g.mapleader = " "

require("config.lazy")
require("config.options")
require("config.keymaps")
require("utils")

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
