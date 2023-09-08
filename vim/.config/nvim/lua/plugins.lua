local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

return require("lazy").setup(
  {
    -- fuzzy
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.2',
      dependencies = { 'nvim-lua/plenary.nvim', "debugloop/telescope-undo.nvim" },
    },

    -- looks
    'vim-airline/vim-airline',
    'arcticicestudio/nord-vim',

    -- git
    'tpope/vim-fugitive',
    { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- lsp
    'neovim/nvim-lspconfig',
    { "williamboman/mason.nvim" },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    "onsails/lspkind.nvim",

    -- debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap" }
    },
    'theHamsta/nvim-dap-virtual-text',
    'szw/vim-maximizer',

    -- utils
    'tpope/vim-commentary',
    'windwp/nvim-autopairs',
    {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" }
      }
    },
    'iamcco/markdown-preview.nvim'
  }
)
