local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end


return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.0',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'vim-airline/vim-airline'
    use 'tpope/vim-commentary'
    use 'tpope/vim-fugitive'
    use 'neovim/nvim-lspconfig'
    use 'windwp/nvim-autopairs'
    use 'arcticicestudio/nord-vim'
    use 'iamcco/markdown-preview.nvim'
    use {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      }
    }
    use 'hrsh7th/nvim-compe'
    use 'puremourning/vimspector'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}  
    use 'szw/vim-maximizer'
end)
