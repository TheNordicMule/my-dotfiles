local buf_set_keymap = vim.keymap.set

-- unbind Q because it's annoying
-- rebind to repeat macro
buf_set_keymap("n", "Q", "@@")

-- center search results
buf_set_keymap("n", "n", "nzz")
buf_set_keymap("n", "N", "Nzz")
buf_set_keymap("n", "*", "*zz")
buf_set_keymap("n", "#", "#zz")
buf_set_keymap("n", "g*", "g*zz")

-- center ctrl u and d
buf_set_keymap("n", "<C-u>", "<C-u>zz")
buf_set_keymap("n", "<C-d>", "<C-d>zz")

-- use default very magic
buf_set_keymap("n", "?", "?\\v")
buf_set_keymap("n", "/", "/\\v")
buf_set_keymap("c", "%s/", "%sm/")

-- map <space>p and <space>y to copy to system clipboard
buf_set_keymap("n", "<leader>p", '"+p')
buf_set_keymap("v", "<leader>p", '"+p')
buf_set_keymap("n", "<leader>P", '"+P')
buf_set_keymap("v", "<leader>P", '"+P')
buf_set_keymap("n", "<leader>y", '"+y')
buf_set_keymap("v", "<leader>y", '"+y')
buf_set_keymap("n", "<leader>Y", '"+y$')
buf_set_keymap("n", "<leader>d", '"_d', { desc = "" })
buf_set_keymap("v", "<leader>d", '"_d', { desc = "" })

-- Go to tab by number
buf_set_keymap("n", "<leader>tt", "<cmd>tabnew<cr>")

-- quick move
buf_set_keymap("v", "J", ":m '>+1<CR>gv=gv")
buf_set_keymap("v", "K", ":m '<-2<CR>gv=gv")

-- add resize
buf_set_keymap("n", "<c-left>", ":vertical resize -2<CR>")
buf_set_keymap("n", "<c-right>", ":vertical resize +2<CR>")
buf_set_keymap("n", "<C-up>", ":horizontal resize -2<CR>")
buf_set_keymap("n", "<C-down>", ":horizontal resize +2<CR>")

buf_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
buf_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

buf_set_keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
buf_set_keymap("n", "<leader>ls", "<cmd>LspRestart<CR>", { desc = "Restart LSP" })
buf_set_keymap("n", "<leader>to", "<cmd>e ~/todo.md<CR>", { desc = "Edit TODO" })

--mark
buf_set_keymap("n", "mh", "mH")
buf_set_keymap("n", "mm", "mM")
buf_set_keymap("n", "ml", "mL")
buf_set_keymap("n", "'h", "'H")
buf_set_keymap("n", "'m", "'M")
buf_set_keymap("n", "'l", "'L")

buf_set_keymap("n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute the current line" })
buf_set_keymap("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })
