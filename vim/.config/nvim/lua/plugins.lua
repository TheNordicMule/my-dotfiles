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
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use 'vim-airline/vim-airline'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'neovim/nvim-lspconfig'

    -- all needed for completion
    -- use 'hrsh7th/cmp-nvim-lsp'
    -- use 'hrsh7th/cmp-buffer'
    -- use 'hrsh7th/cmp-path'
    -- use 'hrsh7th/cmp-cmdline'
    -- use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/nvim-compe'

    use 'windwp/nvim-autopairs'
    use 'arcticicestudio/nord-vim'
    use 'iamcco/markdown-preview.nvim'
    use {'lewis6991/gitsigns.nvim', requires = {'nvim-lua/plenary.nvim'}}
    use 'puremourning/vimspector'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'szw/vim-maximizer'
    use {
        "startup-nvim/startup.nvim",
        requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"},
        config = function() require"startup".setup({theme = "startify"}) end
    }
end)
