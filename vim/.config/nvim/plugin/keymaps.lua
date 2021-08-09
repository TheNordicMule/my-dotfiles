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


