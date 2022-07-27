local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim',
        install_path
    })
    execute 'packadd packer.nvim'
end

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    -- fuzzy
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}}
    }

    -- looks
    use 'vim-airline/vim-airline'
    use 'arcticicestudio/nord-vim'
    use {
        "startup-nvim/startup.nvim",
        requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
        config = function() require"startup".setup({theme = "startify"}) end
    }

    -- git
    use 'tpope/vim-fugitive'
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}

    -- lsp
    use 'neovim/nvim-lspconfig'
    use {"williamboman/mason.nvim"}
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")
    use "rafamadriz/friendly-snippets"
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    -- debugger
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'theHamsta/nvim-dap-virtual-text'
    use 'szw/vim-maximizer'

    -- utils
    use 'tpope/vim-commentary'
    use 'windwp/nvim-autopairs'
    use 'iamcco/markdown-preview.nvim'

end)
