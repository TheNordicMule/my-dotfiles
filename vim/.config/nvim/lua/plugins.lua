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
    {
      'nvim-lualine/lualine.nvim',
      opts = {
        options = {
          icons_enabled = false,
          theme = 'nord',
          component_separators = '|',
          section_separators = '',
        },
      },
    },
    'arcticicestudio/nord-vim',

    -- git
    { 'tpope/vim-fugitive',      dependencies = { 'tpope/vim-rhubarb', } },
    { 'lewis6991/gitsigns.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

    -- lsp
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim',      opts = {} },
        { "williamboman/mason.nvim" },

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
      }
    },
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        -- Additional lua configuration, makes nvim stuff amazing!
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "onsails/lspkind.nvim",
      }
    },

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- debugger
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "mfussenegger/nvim-dap" }
    },
    'theHamsta/nvim-dap-virtual-text',
    'szw/vim-maximizer',

    -- utils
    { 'numToStr/Comment.nvim',           opts = {} },
    'windwp/nvim-autopairs',
    {
      "ThePrimeagen/refactoring.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" }
      }
    },
    -- install without yarn or npm
    {
      "iamcco/markdown-preview.nvim",
      cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
      ft = { "markdown" },
      build = function() vim.fn["mkdp#util#install"]() end,
    }
  }
)
