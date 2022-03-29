-- Mappings.
local silent_opts = { noremap=true, silent=true }
local noremap = { noremap=true }

local buf_set_keymap = vim.api.nvim_set_keymap

-- unbind Q because it's annoying
-- rebind to repeat macro
buf_set_keymap('n', 'Q', '@@', noremap)



-- Try to prevent bad habits like using the arrow keys for movement. This is
-- not the only possible bad habit. For example, holding down the h/j/k/l keys
-- for movement, rather than using more efficient movement commands, is also a
-- bad habit. The former is enforceable through a .vimrc, while we don't know
-- how to prevent the latter.
-- Do this in normal mode...
buf_set_keymap('n','<Left>','<cmd>echoe \'--use h--\'<CR>', noremap)
buf_set_keymap('n','<Right>','<cmd>echoe \'--use l--\'<CR>', noremap)
buf_set_keymap('n','<Up>','<cmd>echoe \'--use k--\'<CR>', noremap)
buf_set_keymap('n','<Down>','<cmd>echoe \'--use j--\'<CR>', noremap)
-- ...and in insert mode
buf_set_keymap('i','<Left>','<cmd>echoe \'--use h--\'<CR>', noremap)
buf_set_keymap('i','<Right>','<cmd>echoe \'--use l--\'<CR>', noremap)
buf_set_keymap('i','<Up>','<cmd>echoe \'--use k--\'<CR>', noremap)
buf_set_keymap('i','<Down>','<cmd>echoe \'--use j--\'<CR>', noremap)


buf_set_keymap('n','<leader>ga','<cmd>Git add %<CR>', noremap)
buf_set_keymap('n','<leader>gd','<cmd>Git diff<CR>', noremap)
buf_set_keymap('n','<leader>gs','<cmd>Git status<CR>', noremap)
buf_set_keymap('n','<leader>gb','<cmd>Git blame<CR>', noremap)
buf_set_keymap('n','<leader>gc','<cmd>Git commit<CR>', noremap)
buf_set_keymap('n','<leader>gr','<cmd>Git restore %<CR>', noremap)
buf_set_keymap('n','<leader>gl','<cmd>Git log<CR>', noremap)
buf_set_keymap('n','<leader>gv','<cmd>Gvdiffsplit!<CR>', noremap)
buf_set_keymap('n','<leader>v','<Plug>MarkdownPreviewToggle', {})


-- center search results
buf_set_keymap('n','n','nzz',silent_opts)
buf_set_keymap('n','N','Nzz',silent_opts)
buf_set_keymap('n','*','*zz',silent_opts)
buf_set_keymap('n','#','#zz',silent_opts)
buf_set_keymap('n','g*','g*zz',silent_opts)

-- use default very magic
buf_set_keymap('n','?','?\\v', noremap)
buf_set_keymap('n','/','/\\v', noremap)
buf_set_keymap('c','%s/','%sm/', noremap)


-- map <space>p and <space>y to copy to system clipboard
buf_set_keymap('n','<leader>p','"+p', noremap)
buf_set_keymap('v','<leader>p','"+p', noremap)
buf_set_keymap('n','<leader>P','"+P', noremap)
buf_set_keymap('v','<leader>P','"+P', noremap)
buf_set_keymap('n','<leader>y','"+y', noremap)
buf_set_keymap('v','<leader>y','"+y', noremap)
buf_set_keymap('n','<leader>Y','"+y$', noremap)
buf_set_keymap('n','<leader>d','"_d', noremap)
buf_set_keymap('v','<leader>d','"_d', noremap)

-- Go to tab by number
buf_set_keymap('n','<leader>t','<cmd>tabnew<cr>', noremap)

-- Quickfix list stuff
buf_set_keymap('n','<leader>cn','<cmd>cn<CR>', noremap)
buf_set_keymap('n','<leader>cp','<cmd>cp<CR>', noremap)

-- quick move
buf_set_keymap('v','J',':m \'>+1<CR>gv=gv', noremap)
buf_set_keymap('v','K',':m \'<-2<CR>gv=gv', noremap)
