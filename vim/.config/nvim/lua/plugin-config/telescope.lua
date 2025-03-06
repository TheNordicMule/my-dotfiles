-- telescope remap
vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>")
vim.keymap.set("n", "<Leader>tp", function()
	require("telescope.builtin").find_files({ hidden = true })
end)

vim.keymap.set("n", "<Leader>ts", function()
	require("telescope.builtin").grep_string({
		search = vim.fn.input("Grep For > "),
		use_regex = true,
	})
end)

vim.keymap.set("n", "<Leader>tw", function()
	require("telescope.builtin").grep_string({
		search = vim.fn.expand("<cword>"),
	})
end)

vim.keymap.set("n", "<Leader>tb", function()
	require("telescope.builtin").buffers()
end)

vim.keymap.set("n", "<Leader>tq", function()
	require("telescope.builtin").quickfix()
end)

vim.keymap.set("n", "<Leader>tr", function()
	require("telescope.builtin").registers()
end)

vim.keymap.set("n", "<Leader>td", function()
	require("telescope.builtin").diagnostics()
end)

vim.keymap.set("n", "<Leader>th", function()
	require("telescope.builtin").help_tags()
end)

vim.keymap.set("n", "<Leader>tc", function()
	require("telescope.builtin").commands()
end)

vim.keymap.set("n", "<Leader>tg", function()
	require("telescope.builtin").git_branches()
end)

local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		prompt_prefix = " >",
		color_devicons = true,
		mappings = {
			n = {
				["<C-S-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
			i = {
				["<C-S-Q>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})

pcall(require("telescope").load_extension, "ui-select")
