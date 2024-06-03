vim.g.mapleader = " "

require("plugins")
require("utils")
require("plugin-config.cmp")
require("plugin-config.conform")
require("plugin-config.dap")
require("plugin-config.gitsigns")
require("plugin-config.harpoon")
require("plugin-config.linter")
require("plugin-config.lsp")
require("plugin-config.neotest")
require("plugin-config.nvim-autopairs")
require("plugin-config.telescope")
require("plugin-config.treesitter")

vim.cmd([[
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow\ --multiline-dotall
]])

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd([[
au VimEnter * hi Normal guibg=none
au VimEnter * hi Normal ctermbg=none
au VimEnter * hi LineNr guibg=none
au VimEnter * hi LineNr ctermbg=none
au VimEnter * hi Folded guibg=none
au VimEnter * hi Folded ctermbg=none
au VimEnter * hi NonText ctermbg=none
au VimEnter * hi NonText guibg=none
au VimEnter * hi SpecialKey ctermbg=none
au VimEnter * hi SpecialKey guibg=none
au VimEnter * hi VertSplit ctermbg=none
au VimEnter * hi VertSplit guibg=none
au VimEnter * hi SignColumn ctermbg=none
au VimEnter * hi SignColumn guibg=none
au VimEnter * hi EndOfBuffer ctermbg=none
au VimEnter * hi EndOfBuffer guibg=none
]])
