vim.cmd([[colorscheme nord]])
vim.g.mapleader = " "

require 'plugins'
require 'utils'
require 'plugin-config.cmp-config'
require 'plugin-config.refactor-config'
require 'plugin-config.dap-config'
require 'plugin-config.gitsigns-config'
require 'plugin-config.lsp-config'
require 'plugin-config.nvim-autopairs-config'
require 'plugin-config.telescope-config'
require 'plugin-config.treesitter-config'


vim.cmd([[
" setup grep for vim to use rg
if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow\ --multiline-dotall
elseif executable('ag')
    set grepprg=ag\ --vimgrep\ --smart-case\ --hidden\ --follow
else
    set grepprg=grep\ --line-number\ --ignore-case\ -H\ --exclude=tags*
endif

" nerdtree like 
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 15

augroup highlight_yank
autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout = 200})
augroup END

]])


vim.cmd[[
au VimEnter * hi Normal guibg=none
au VimEnter * hi Normal ctermbg=none
au VimEnter * hi LineNr guibg=none
au VimEnter * hi LineNr ctermbg=none
au VimEnter * hi Folded guibg=none 
au VimEnter * hi Folded ctermbg=none
au VimEnter * hi NonText ctermbg=none
au VimEnter * hi NonText guibg=none 
au VimEnter * hi SpecialKey ctermbg=none
au VimEnter * hi SpecialKey guibg=none
au VimEnter * hi VertSplit ctermbg=none
au VimEnter * hi VertSplit guibg=none
au VimEnter * hi SignColumn ctermbg=none
au VimEnter * hi SignColumn guibg=none
au VimEnter * hi EndOfBuffer ctermbg=none
au VimEnter * hi EndOfBuffer guibg=none
]]

