-- telescope remap
vim.keymap.set('n', '<C-p>', '<cmd>Telescope git_files<cr>')
vim.keymap.set('n', '<Leader>tp', '<cmd>lua require("telescope.builtin").find_files({ hidden=true })<CR>')
vim.keymap.set('n', '<Leader>ts',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > "), use_regex=true})<CR>')

vim.keymap.set('n', '<Leader>tw',
  '<cmd>lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>")})<CR>')

vim.keymap.set('n', '<Leader>tb',
  '<cmd>lua require("telescope.builtin").buffers()<CR>')

vim.keymap.set('n', '<Leader>tq',
  '<cmd>lua require("telescope.builtin").quickfix()<CR>')

vim.keymap.set('n', '<Leader>tr',
  '<cmd>lua require("telescope.builtin").registers()<CR>')

vim.keymap.set('n', '<Leader>td',
  '<cmd>lua require("telescope.builtin").diagnostics()<CR>')

vim.keymap.set('n', '<Leader>th',
  '<cmd>lua require("telescope.builtin").help_tags()<CR>')

vim.keymap.set('n', '<Leader>tc',
  '<cmd>lua require("telescope.builtin").commands()<CR>')

local actions = require "telescope.actions"

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
      }
    }
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
  pickers = {
    find_files = {
      hidden = true
    },
  },
})

pcall(require('telescope').load_extension, 'ui-select')
