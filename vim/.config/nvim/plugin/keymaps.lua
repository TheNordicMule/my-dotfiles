local buf_set_keymap = vim.keymap.set

-- unbind Q because it's annoying
-- rebind to repeat macro
buf_set_keymap("n", "Q", "@@")

-- Try to prevent bad habits like using the arrow keys for movement. This is
-- not the only possible bad habit. For example, holding down the h/j/k/l keys
-- for movement, rather than using more efficient movement commands, is also a
-- bad habit. The former is enforceable through a .vimrc, while we don't know
-- how to prevent the latter.
-- Do this in normal mode...
buf_set_keymap("n", "<Left>", "<cmd>echoe '--use h--'<CR>")
buf_set_keymap("n", "<Right>", "<cmd>echoe '--use l--'<CR>")
buf_set_keymap("n", "<Up>", "<cmd>echoe '--use k--'<CR>")
buf_set_keymap("n", "<Down>", "<cmd>echoe '--use j--'<CR>")
-- ...and in insert mode
buf_set_keymap("i", "<Left>", "<cmd>echoe '--use h--'<CR>")
buf_set_keymap("i", "<Right>", "<cmd>echoe '--use l--'<CR>")
buf_set_keymap("i", "<Up>", "<cmd>echoe '--use k--'<CR>")
buf_set_keymap("i", "<Down>", "<cmd>echoe '--use j--'<CR>")

buf_set_keymap("n", "<leader>ga", "<cmd>Git add %<CR>")
buf_set_keymap("n", "<leader>gd", "<cmd>Git diff<CR>")
buf_set_keymap("n", "<leader>gs", "<cmd>Git<CR>")
buf_set_keymap("n", "<leader>gb", "<cmd>Git blame<CR>")
buf_set_keymap("n", "<leader>gc", "<cmd>Git commit<CR>")
buf_set_keymap("n", "<leader>gr", "<cmd>Git restore %<CR>")
buf_set_keymap("n", "<leader>gl", "<cmd>Git log<CR>")
buf_set_keymap("n", "<leader>gv", "<cmd>Gvdiffsplit!<CR>")
buf_set_keymap("n", "<leader>gh", "<cmd>GBrowse<CR>")
buf_set_keymap("n", "gp", "<cmd>!Git pull<CR>")

-- markdown
buf_set_keymap("n", "<leader>v", "<Plug>MarkdownPreviewToggle")

-- undo tree
buf_set_keymap("n", "<leader>u", "<cmd>UndotreeToggle<CR>")

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
buf_set_keymap("n", "<leader>d", '"_d')
buf_set_keymap("v", "<leader>d", '"_d')

-- Go to tab by number
buf_set_keymap("n", "<leader>tt", "<cmd>tabnew<cr>")

-- Quickfix list stuff
buf_set_keymap("n", "]q", "<cmd>cn<CR>")
buf_set_keymap("n", "[q", "<cmd>cp<CR>")

-- quick move
buf_set_keymap("v", "J", ":m '>+1<CR>gv=gv")
buf_set_keymap("v", "K", ":m '<-2<CR>gv=gv")

-- add resize
buf_set_keymap("n", "<leader>+", ":vertical resize +5<CR>")
buf_set_keymap("n", "<leader>-", ":vertical resize -5<CR>")
buf_set_keymap("n", "<C-w>+", ":vertical resize +5<CR>")
buf_set_keymap("n", "<C-w>-", ":vertical resize -5<CR>")

buf_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
buf_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

buf_set_keymap("n", "<leader>fe", ":Oil<CR>")
buf_set_keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
buf_set_keymap("n", "<leader>ls", "<cmd>LspRestart<CR>")
buf_set_keymap("n", "<leader>to", "<cmd>e ~/todo.md<CR>")

--mark
buf_set_keymap("n", "mh", "mH")
buf_set_keymap("n", "mm", "mM")
buf_set_keymap("n", "ml", "mL")
buf_set_keymap("n", "'h", "'H")
buf_set_keymap("n", "'m", "'M")
buf_set_keymap("n", "'l", "'L")
