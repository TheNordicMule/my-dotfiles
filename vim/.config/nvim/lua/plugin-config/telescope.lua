-- telescope remap
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>Telescope git_files<cr>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>tp', '<cmd>lua require("telescope.builtin").find_files({ hidden=true })<CR>',
  { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>ts',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > "), use_regex=true})<CR>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>tw',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>")})<CR>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>tb',
  '<cmd>lua require("telescope.builtin").buffers()<CR>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>tq',
  '<cmd>lua require("telescope.builtin").quickfix()<CR>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>tr',
  '<cmd>lua require("telescope.builtin").registers()<CR>',
  { noremap = true })

vim.api.nvim_set_keymap('n', '<Leader>th',
  '<cmd>lua require("telescope.builtin").help_tags()<CR>',
  { noremap = true })

require("telescope").setup({
  defaults = {
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    prompt_prefix = " >",
    color_devicons = true,
  },
  pickers = {
    find_files = {
      hidden = true
    },
  },
})
